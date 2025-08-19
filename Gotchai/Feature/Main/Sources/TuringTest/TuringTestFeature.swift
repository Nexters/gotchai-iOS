//
//  TuringTestFeature.swift
//  Main
//
//  Created by 가은 on 8/2/25.
//

import Foundation
import Combine
import TCA
import UIKit
import SwiftUI
import Common

@Reducer
public struct TuringTestFeature {
    @Dependency(\.turingTestService) var turingTestService

    enum CancelID {
        case getTuringTestItem
        case postTuringTestStart
        case submitTuringTest
        case toastTimer
    }

    public init() { }

    @ObservableState
    public struct State {
        var turingTestID: Int
        var turingTest: TuringTest
        var resultBadge: ResultBadge?
        var toastMessage: String = ""
        var showToastMessage: Bool = false
        public init(turingTestID: Int = -1, turingTest: TuringTest = TuringTest.dummy, resultBadge: ResultBadge? = nil) {
            self.turingTestID = turingTestID
            self.turingTest = turingTest
            self.resultBadge = resultBadge
        }
    }

    public enum Delegate {
        case moveToConceptView(Int, TuringTest)
        case moveToQuizView(quizIds: [Int], backgroundImageURL: String)
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
        case copyPromptButton
        case hideToast
        case showToast(String)
        
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
                
            // MARK: - 배지 인스타 공유
            case .tappedTestShareButton:
                guard let badge = state.resultBadge else { return .none }
                guard let key = Bundle.main.object(forInfoDictionaryKey: "META_KEY") as? String else {
                    fatalError("❌ Meta Key is missing in Info.plist")
                }
                guard let instagramURL = URL(string:
                                                "instagram-stories://share?source_application=" +
                                             key) else { return .none }

                let gradientStops = GradientHelper.getGradientStops(for: badge.tier)
                let backgroundColors = GradientHelper.getColors(for: badge.tier).mainBackground

                if let uiImage = BadgeCardView(badge: badge,
                                               badgeLinearBackground: gradientStops.badgeLinearBackground,
                                               badgeRadialBackground: gradientStops.badgeRadialBackground ).snapshot() {
                    let imageData = uiImage.pngData()

                    // 1) Pasteboard
                    let items: [String: Any] = [
                        "com.instagram.sharedSticker.stickerImage": imageData ?? Data(),
                        "com.instagram.sharedSticker.backgroundTopColor": "#\(backgroundColors.first ?? "1D1E22")",
                        "com.instagram.sharedSticker.backgroundBottomColor": "#\(backgroundColors.last ?? "1D1E22")"
                    ]
                    UIPasteboard.general.setItems([items], options: [
                        .expirationDate: Date().addingTimeInterval(300) // 5분 유효(선택)
                    ])

                    // 2) instagram-stories://share?source_application=<bundle id>
                    var comps = URLComponents()
                    comps.scheme = "instagram-stories"
                    comps.host = "share"
                    comps.queryItems = [
                        URLQueryItem(name: "source_application", value: Bundle.main.bundleIdentifier)
                    ]
                    guard let url = comps.url else { return .none }

                    // 3) 열기
                    DispatchQueue.main.async {
                        if UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        } else if let store = URL(string: "itms-apps://itunes.apple.com/app/389801252") {
                            UIApplication.shared.open(store, options: [:], completionHandler: nil)
                        }
                    }
                }

                return .none

            // MARK: - 이미지 저장
            case .tappedSaveBadgeButton:
                guard let badge = state.resultBadge else { return .none }

                let gradientStops = GradientHelper.getGradientStops(for: badge.tier)

                let saveEffect: Effect<Action> = .run { _ in
                    if let uiImage = await BadgeCardView(
                        badge: badge,
                        badgeLinearBackground: gradientStops.badgeLinearBackground,
                        badgeRadialBackground: gradientStops.badgeRadialBackground,
                        backgroundColor: Color(.gray_950)
                    ).snapshot() {
                        savePNGToPhotos(uiImage)
                    }
                }

                let toastEffect = createToastEffect(message: "이미지를 저장했어요")

                return .merge(saveEffect, toastEffect)


            case .getResultBadge:
                return .publisher {
                    turingTestService.submitTest(.submitTest(state.turingTestID))
                        .map { .submitTuringTestResponse(.success($0)) }
                        .catch { Just(.submitTuringTestResponse(.failure($0))) }
                        .receive(on: RunLoop.main)
                }
                .cancellable(id: CancelID.submitTuringTest)
            
            case .copyPromptButton:
                // 프롬프트 복사
                let prompt = state.turingTest.prompt
                let copyEffect: Effect<Action> = .run { _ in
                    await MainActor.run {
                        UIPasteboard.general.string = prompt
                    }
                }
                
                let toastEffect = createToastEffect(message: "프롬프트를 복사했어요")
                
                return .merge(copyEffect, toastEffect)
                
            case .showToast(let message):
                state.toastMessage = message
                state.showToastMessage = true
                return .none
            
            case .hideToast:
                state.toastMessage = ""
                state.showToastMessage = false
                return .none
            
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
                    return .send(.delegate(.moveToQuizView(quizIds: quizIds, backgroundImageURL: state.turingTest.backgroundImageURL)))
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
    
    private func createToastEffect(message: String) -> Effect<TuringTestFeature.Action> {
        .run { send in
            // showToast 액션 전송
            await send(.showToast(message))
            
            // 2초 지연
            try await Task.sleep(nanoseconds: 2 * 1_000_000_000)
            
            // hideToast 액션 전송
            await send(.hideToast)
        }
        .cancellable(id: CancelID.toastTimer, cancelInFlight: true)
    }
}
