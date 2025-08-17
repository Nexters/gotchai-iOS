//
//  TuringTestService.swift
//  Main
//
//  Created by 가은 on 8/13/25.
//

import Combine
import CustomNetwork
import UIKit

struct TuringTestService {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func getTestList(_ target: TuringTestAPI) -> AnyPublisher<[TuringTestCard], Error> {
        networkClient
            .request(target, type: TuringTestListResponseDTO.self)
            .handleEvents(receiveOutput: { response in
                print("✅ 테스트 리스트 응답: \(response)")
            })
            .map { dto in
                let convertedData = dto.list.map { itemDto in
                    TuringTestCard(
                        id: itemDto.id,
                        imageURL: itemDto.iconImage,
                        title: itemDto.title,
                        subtitle: itemDto.subTitle,
                        isSolved: itemDto.isSolved ?? false
                    )
                }
                return convertedData
            }
            .eraseToAnyPublisher()
    }

    func getTuringTest(_ target: TuringTestAPI) -> AnyPublisher<TuringTest, Error> {
        networkClient
            .request(target, type: TuringTestItemDTO.self)
            .map { dto in
                TuringTest(
                    id: dto.id,
                    iconURL: dto.iconImage,
                    imageURL: dto.coverImage,
                    title: dto.title,
                    subtitle: dto.subTitle,
                    explanation: dto.description,
                    backgroundImageURL: dto.backgroundImage,
                    theme: dto.theme,
                    prompt: dto.prompt
                )
            }
            .eraseToAnyPublisher()
    }

    func startTuringTest(_ target: TuringTestAPI) -> AnyPublisher<[Int], Error> {
        networkClient
            .request(target, type: TuringTestStartResponseDTO.self)
            .map { dto in
                dto.quizIds
            }
            .eraseToAnyPublisher()
    }

    func getQuiz(_ target: TuringTestAPI) -> AnyPublisher<Quiz, Error> {
        networkClient
            .request(target, type: GetQuizDTO.self)
            .map { dto in
                let answers = dto.quizPicks.map { answerDto in
                    Answer(id: answerDto.id, contents: answerDto.contents)
                }
                return Quiz(id: dto.id, contents: dto.contents, answers: answers)
            }
            .eraseToAnyPublisher()
    }

    func gradeQuiz(_ target: TuringTestAPI) -> AnyPublisher<AnswerPopUp, Error> {
        networkClient
            .request(target, type: GradeQuizResponseDTO.self)
            .map { dto in
                AnswerPopUp(
                    answer: dto.contents,
                    status: dto.isTimeout ? .timeout : dto.isAnswer ? .correct : .incorrect
                )
            }
            .eraseToAnyPublisher()
    }

    func submitTest(_ target: TuringTestAPI) -> AnyPublisher<ResultBadge, Error> {
        networkClient
            .request(target, type: SubmitTuringTestResponseDTO.self)
            .flatMap { dto -> AnyPublisher<ResultBadge, Error> in
                guard let url = URL(string: dto.badge.image) else {
                    return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
                }

                return URLSession.shared.dataTaskPublisher(for: url)
                    .tryMap { data, _ in
                        guard let uiImage = UIImage(data: data) else {
                            throw URLError(.cannotDecodeContentData)
                        }
                        return ResultBadge(
                            image: uiImage,
                            badgeName: dto.badge.name,
                            description: dto.badge.description,
                            tier: GradientTheme(rawValue: dto.badge.tier) ?? .bronze,
                            correctCount: dto.answerCount
                        )
                    }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
