//
//  QuizView.swift
//  Main
//
//  Created by 가은 on 8/2/25.
//

import TCA
import DesignSystem
import SwiftUI
import Kingfisher

public struct QuizView: View {
    let store: StoreOf<QuizFeature>
    
    public init(store: StoreOf<QuizFeature>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(alignment: .leading) {
                
                let progress = CGFloat(viewStore.secondsElapsed) / CGFloat(viewStore.totalSeconds)
                TimerBar(progress: progress)
                    .padding(.top, 4)
                    .padding(.bottom, 28)
                
                Text("\(viewStore.quizIndex+1)/\(viewStore.quizIdList.count)")
                    .fontStyle(.body_5)
                    .foregroundStyle(Color(.primary_400))
                    .padding(.vertical, 3)
                    .padding(.horizontal, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(.primary_400).opacity(0.1))
                    )
                
                Text(viewStore.quiz.contents)
                    .fontStyle(.subtitle_2)
                    .foregroundStyle(Color(.gray_white))
                    .padding(.top, 16)
                
                VStack(spacing: 16) {
                    ForEach(Array(viewStore.quiz.answers.enumerated()), id: \.offset) { index, item in
                        Button {
                            viewStore.send(.selectAnswer(index, item.id, false))
                        } label: {
                            AnswerCard(idx: index, text: item.contents, state: viewStore.answerCardState[index])
                        }
                        .allowsHitTesting(!viewStore.state.isSelectedAnswer)    // 답 선택하면 터치 막기
                    }
                }
                .padding(.top, 76)
                
                Spacer()
            }
            .padding(.horizontal, 24)
            .background(
                ZStack {
                    KFImage(URL(string: viewStore.backgroundImageURL))
                        .resizable()
                        .placeholder { ProgressView() }
                        .blur(radius: 90)
                    Color(.gray_black).opacity(0.7)
                }.ignoresSafeArea()
            )
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewStore.send(.tappedXButton)
                    } label: {
                        Image("icon_xmark", bundle: .module)
                            .padding(12)
                    }
                }
            }
            .answerPopUp(
                isPresented: viewStore.binding(
                    get: \.isAnswerPopUpPresented,
                    send: QuizFeature.Action.setAnswerPopUpPresented),
                quizProgress: viewStore.answerPopUpData.status,
                answerText: viewStore.answerPopUpData.answer,
                action: {
                    if viewStore.quizIndex == viewStore.quizIdList.count - 1 {
                        viewStore.send(.delegate(.moveToResultView))
                    } else {
                        viewStore.send(.initQuiz)
                    }
                }
            )
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
    
    @ViewBuilder
    private func TimerBar(progress: CGFloat) -> some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color(.gray_white).opacity(0.2))
                    .frame(maxWidth: .infinity)
            
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color(.primary_400))
                    .frame(width: geometry.size.width * progress)
                    .animation(progress == 0 ? nil : .linear(duration: 1), value: progress)
            }
        }
        .frame(height: 5)
        .padding(.vertical, 4)
    }
    
    @ViewBuilder
    private func AnswerCard(idx: Int, text: String, state: AnswerCardState) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(idx == 0 ? "A" : "B")
                .fontStyle(.body_3)
                .foregroundStyle(Color(.gray_black))
                .padding(.vertical, 4)
                .padding(.horizontal, 10)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(state == .unselected ? Color(.gray_white).opacity(0.3) : Color(.primary_400))
                )
            Text(text)
                .fontStyle(.body_4)
                .foregroundStyle(Color(.gray_white))
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 20)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(backgroundColor(state))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(state == .selected ? Color(.primary_400).opacity(0.15) : .clear, lineWidth: 0.5)
        )
    }
    
    private func backgroundColor(_ state: AnswerCardState) -> Color {
        switch state {
        case .idle:
            return Color(.gray_white).opacity(0.15)
        case .selected:
            return Color(.primary_400).opacity(0.15)
        case .unselected:
            return Color(.gray_white).opacity(0.05)
        }
    }
}

#Preview {
    QuizView(store: Store(initialState: QuizFeature.State(), reducer: {
        QuizFeature()
    }))
}
