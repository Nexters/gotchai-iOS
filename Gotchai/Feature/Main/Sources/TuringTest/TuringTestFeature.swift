//
//  TuringTestFeature.swift
//  Main
//
//  Created by 가은 on 8/2/25.
//

import Foundation
import Combine
import TCA
import SwiftUI

@Reducer
public struct TuringTestFeature {
    @Dependency(\.turingTestService) var turingTestService

    enum CancelID {
        case getTuringTestItem
        case postTuringTestStart
        case submitTuringTest
    }

    public init() { }

    @ObservableState
    public struct State {
        var turingTestID: Int
        var turingTest: TuringTest
        var resultBadge: ResultBadge?

        public init(turingTestID: Int = -1,
                    turingTest: TuringTest = .dummy,
                    resultBadge: ResultBadge? = nil) {
            self.turingTestID = turingTestID
            self.turingTest = turingTest
            self.resultBadge = resultBadge
        }
    }

    public enum Delegate {
        case moveToConceptView(Int, TuringTest)
        case moveToQuizView([Int])
        case moveToMainView
    }

    public enum Action {
        // life cycle
        case onAppearIntroView

        // view
        case tappedTestShareButton
        case tappedSaveBadgeButton
        case tappedStartButton
        case tappedNextButton
        case tappedBackButton
        case delegate(Delegate)
        case getResultBadge

        // data
        case getTuringTestResponse(Result<TuringTest, Error>)
        case postTuringTestStartResponse(Result<[Int], Error>)
        case submitTuringTestResponse(Result<ResultBadge, Error>)
    }

    public var body: some ReducerOf<Self> {
        Reduce {
 state,
 action in
            switch action {
                // MARK: - Action: Life Cycle
            case .onAppearIntroView:
                // 데이터 fetch
                return .publisher {
                    turingTestService.getTuringTest(.getTestDetail(state.turingTestID))
                        .map { TuringTestFeature.Action.getTuringTestResponse(.success($0)) }
                        .catch{ Just(.getTuringTestResponse(.failure($0))) }
                        .receive(on: RunLoop.main)
                }
                .cancellable(id: CancelID.getTuringTestItem)

                // MARK: - Action: 화면 전환 & 단순 작업
            case .tappedStartButton:
                return .send(.delegate(.moveToConceptView(state.turingTestID, state.turingTest)))
            case .tappedBackButton:
                return .send(.delegate(.moveToMainView))
            case .tappedNextButton:
                return .publisher {
                    turingTestService.startTuringTest(.postTestStart(state.turingTestID))
                        .map { .postTuringTestStartResponse(.success($0)) }
                        .catch { Just(.postTuringTestStartResponse(.failure($0))) }
                        .receive(on: RunLoop.main)
                }
                .cancellable(id: CancelID.postTuringTestStart)
            case .tappedTestShareButton:
                guard let badge = state.resultBadge else { return .none }
                guard let key = Bundle.main.object(forInfoDictionaryKey: "META_KEY") as? String else {
                    fatalError("❌ Meta Key is missing in Info.plist")
                }
                guard let instagramURL = URL(string:
                      "instagram-stories://share?source_application=" +
                                             key) else { return .none }
                
                if let uiImage = BadgeCardView(badge: badge).snapshot() {
                    let imageData = uiImage.pngData()

                    let pasteboardItems: [String: Any] = [
                        "com.instagram.sharedSticker.stickerImage": imageData,
                        "com.instagram.sharedSticker.backgroundTopColor" : "#FC5555",
                        "com.instagram.sharedSticker.backgroundBottomColor" : "#176AB7"
                    ]

                    // ① pasteboard에 저장 (만료 옵션을 줄 수도 있음)
                    UIPasteboard.general.setItems([pasteboardItems], options: [:])

                    // ② Instagram 실행
                    if UIApplication.shared.canOpenURL(instagramURL) {
                        UIApplication.shared.open(instagramURL, options: [:], completionHandler: nil)
                    } else {
                        // 인스타그램 없을 경우 App Store로
                        if let appStoreURL = URL(string: "itms-apps://itunes.apple.com/app/389801252") {
                            UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
                        }
                    }
                }

                return .none

            case .tappedSaveBadgeButton:
                guard let badge = state.resultBadge else { return .none }

                return .run { _ in
                    if let uiImage = await BadgeCardView(badge: badge).snapshot() {
                    UIImageWriteToSavedPhotosAlbum(uiImage, nil, nil, nil)
                  }
                }

            case .getResultBadge:
                return .publisher {
                    turingTestService.submitTest(.submitTest(state.turingTestID))
                        .map { .submitTuringTestResponse(.success($0)) }
                        .catch { Just(.submitTuringTestResponse(.failure($0))) }
                        .receive(on: RunLoop.main)
                }
                .cancellable(id: CancelID.submitTuringTest)

                // MARK: - Action: 데이터 응답 처리
            case .getTuringTestResponse(let result):
                switch result {
                case .success(let turingTest):
                    state.turingTest = turingTest
                    return .none
                case .failure(let error):
                    print("테스트 데이터 fetch 실패:", error)
                    return .none
                }
            case .postTuringTestStartResponse(let result):
                switch result {
                case .success(let quizIds):
                    return .send(.delegate(.moveToQuizView(quizIds)))
                case .failure(let error):
                    print("테스트 시작 실패:", error)
                    return .none
                }
            case .submitTuringTestResponse(let result):
                switch result {
                case .success(let badge):
                    state.resultBadge = badge
                    return .none
                case .failure(let error):
                    print("테스트 제출 실패:", error)
                    return .none
                }
            default:
                return .none
            }
        }
    }
}
