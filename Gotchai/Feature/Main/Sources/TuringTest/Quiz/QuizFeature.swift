//
//  QuizFeature.swift
//  Main
//
//  Created by 가은 on 8/3/25.
//

import Combine
import CustomNetwork
import TCA
import SwiftUI

@Reducer
public struct QuizFeature {
    @Dependency(\.turingTestService) var turingTestService
    
    public enum CancelID {
        case timer
        case getQuiz
        case gradeQuiz
    }
    
    public init() { }
    
    @ObservableState
    public struct State: Equatable {
        // Timer
        var secondsElapsed: Int = 0
        let totalSeconds: Int = 10
        var isRunningTimer = false
        
        // Quiz
        var quizIdList: [Int]
        var quizIndex: Int = -1
        var quiz: Quiz
        var backgroundImageURL: String
        var answerCardState: [AnswerCardState]
        var isSelectedAnswer: Bool = false
        var answerPopUpData: AnswerPopUp = .init(answer: "", status: .notAnswered)
        var isAnswerPopUpPresented: Bool
        
        public init(
            quizIdList: [Int] = [],
            quiz: Quiz = Quiz.dummy,
            backgroundImageURL: String = "",
            isAnswerPopUpPresented: Bool = false
        ) {
            self.quizIdList = quizIdList
            self.quiz = quiz
            self.backgroundImageURL = backgroundImageURL
            self.answerCardState = Array(repeating: .idle, count: quiz.answers.count)
            self.isAnswerPopUpPresented = isAnswerPopUpPresented
        }
    }
    
    public enum Delegate {
        case moveToMainView
        case moveToResultView
    }
    
    public enum Action {
        // Life Cycle
        case onAppear
        
        // Timer
        case startTimer
        case stopTimer
        case tick
        
        // Quiz
        case initQuiz
        case selectAnswer(Int, Int, Bool)
        case setAnswerPopUpPresented(Bool)
        case tappedXButton
        case delegate(Delegate)
        
        // Data
        case getQuizResponse(Result<Quiz, Error>)
        case gradeQuizResponse(Result<AnswerPopUp, Error>)
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            // MARK: - Action: Life Cycle
            case .onAppear:
                return .send(.initQuiz)
                
            // MARK: - Action: Timer
            case .startTimer:
                state.secondsElapsed = 0
                state.isRunningTimer = true
                
                return .run { send in
                    await send(.tick)
                    let timerSequence = Timer.publish(every: 1.0, on: .main, in: .common)
                        .autoconnect()
                        .values
                    
                    for await _ in timerSequence {
                        await send(.tick)
                    }
                }
                .cancellable(id: CancelID.timer)
            case .stopTimer:
                state.isRunningTimer = false
                return .cancel(id: CancelID.timer)
            case .tick:
                if state.secondsElapsed < state.totalSeconds {
                    state.secondsElapsed += 1
                    return .none
                } else {
                    state.isRunningTimer = false
                    return .concatenate(
                        .cancel(id: CancelID.timer),
                        .send(.selectAnswer(-1, 0, true)) // 임시 값, 10초가 되었을 때 이후 작업을 하기 위함
                    )
                }
            
            // MARK: - Action: 정답 선택
            case let .selectAnswer(index, id, isTimeOut):
                if state.isSelectedAnswer { return .none }
                
                state.isRunningTimer = false
                state.isSelectedAnswer = true
                
                for i in 0..<state.answerCardState.count {
                    if i == index {
                        state.answerCardState[i] = .selected
                    } else {
                        state.answerCardState[i] = .unselected
                    }
                }
                
                let req = GradeQuizRequestDTO(quizPickId: id, isTimeout: isTimeOut)
                
                return .concatenate(
                    .cancel(id: CancelID.timer),
                    .publisher {
                        turingTestService.gradeQuiz(.gradeQuiz(state.quizIdList[state.quizIndex], req))
                            .map { .gradeQuizResponse(.success($0)) }
                            .catch{ Just(.gradeQuizResponse(.failure($0))) }
                            .receive(on: RunLoop.main)
                    }.cancellable(id: CancelID.gradeQuiz)
                )
            
            // MARK: - Action: 퀴즈 초기화
            case .initQuiz:
                state.quizIndex += 1
                state.isSelectedAnswer = false
                state.answerCardState = Array(repeating: .idle, count: state.quiz.answers.count)
                
                return .publisher {
                    turingTestService.getQuiz(.getQuiz(state.quizIdList[state.quizIndex]))
                        .map { .getQuizResponse(.success($0)) }
                        .catch{ Just(.getQuizResponse(.failure($0))) }
                        .receive(on: RunLoop.main)
                }
                .cancellable(id: CancelID.getQuiz)
                
            // MARK: - Action: 화면 전환 & 단순 state 변경
            case .tappedXButton:
                return .send(.delegate(.moveToMainView))
            case let .setAnswerPopUpPresented(isPresented):
                state.isAnswerPopUpPresented = isPresented
                return .none
                
            // MARK: - Action: 데이터 응답 처리
            case let .getQuizResponse(result):
                switch result {
                case let .success(quiz):
                    state.quiz = quiz
                    return .send(.startTimer)
                case let .failure(error):
                    print("퀴즈 fetch 실패: \(error)")
                    return .none
                }
            case let .gradeQuizResponse(result):
                switch result {
                case let .success(response):
                    state.answerPopUpData = .init(answer: response.answer, status: response.status)
                    
                    return .publisher {
                        Just(.setAnswerPopUpPresented(true))
                            .delay(for: .seconds(0.3), scheduler: RunLoop.main)
                            .eraseToAnyPublisher()
                    }
                case let .failure(error):
                    print("퀴즈 채점 실패: \(error)")
                    return .none
                }
            default:
                return .none
            }
        }
    }
}

public enum QuizProgress: Equatable {
    case notAnswered
    case correct
    case incorrect
    case timeout
}

enum AnswerCardState {
    case idle
    case selected
    case unselected
}
