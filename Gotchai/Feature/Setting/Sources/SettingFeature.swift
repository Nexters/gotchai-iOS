//
//  SettingFeature.swift
//  Setting
//
//  Created by 가은 on 8/13/25.
//

import TCA
import Auth
import Foundation
import Combine
import Key
import SwiftUI

@Reducer
public struct SettingFeature {
    @Dependency(\.authClient) var authClient
    @Dependency(\.tokenProvider) var tokenProvider
    @Dependency(\.settingService) var settingService

    public init() { }

    @ObservableState
    public struct State: Equatable {
        var isPresentedPopUp: Bool
        var popUpType: SettingPopUpType?

        public init(isPresentedPopUp: Bool = false, popUpType: SettingPopUpType? = nil) {
            self.isPresentedPopUp = isPresentedPopUp
            self.popUpType = popUpType
        }
    }

    public enum Delegate {
        case moveToMainView
        case didLogout
    }

    public enum Action: Equatable {
        case tappedBackButton
        case tappedGetFeedbackButton
        case logout
        case logoutSucceeded
        case logoutFailed(String)
        case delete
        case showPopUp(SettingPopUpType)
        case setIsPresentedPopUp(Bool)  // 바인딩용
        case delegate(Delegate)
    }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .tappedBackButton:
                return .send(.delegate(.moveToMainView))
                
            case let .showPopUp(type):
                state.isPresentedPopUp = true
                state.popUpType = type
                return .none

            case let .setIsPresentedPopUp(flag):
                state.isPresentedPopUp = flag
                return .none

            case .logout:
                return .publisher {
                    authClient.signOut()
                        .map { _ in .logoutSucceeded }    // 성공 시 액션 변환
                        .catch { error in                 // 실패 시 액션 변환
                            Just(.logoutFailed(error.localizedDescription))
                        }
                        .receive(on: DispatchQueue.main)  // UI 업데이트 안전
                }

            case .logoutSucceeded:
                // 로컬 토큰/세션 정리(필요 시)
                tokenProvider.accessToken = nil
                state.isPresentedPopUp = false
                state.popUpType = nil

                return .publisher {
                  settingService.signOut()    // 서버에 세션 종료 통보
                    .map { _ in .delegate(.didLogout) }
                    .catch { _ in Just(.delegate(.didLogout)) } // 실패해도 UX 진행
                    .receive(on: DispatchQueue.main)
                }

            case .logoutFailed(let message):
                state.isPresentedPopUp = false
                print("로그아웃 실패: \(message)")
                return .none

            case .delete:
                tokenProvider.accessToken = nil
                state.isPresentedPopUp = false
                state.popUpType = nil

                return .publisher {
                  settingService.delete()    // 서버에 세션 종료 통보
                    .map { _ in .delegate(.didLogout) }
                    .catch { _ in Just(.delegate(.didLogout)) } // 실패해도 UX 진행
                    .receive(on: DispatchQueue.main)
                }

            default: return .none
            }
        }
    }
}

public enum SettingPopUpType: Equatable {
    case logout, delete
}
