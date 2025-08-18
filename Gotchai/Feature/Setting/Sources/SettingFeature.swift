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
        case deleteSucceeded
        case deleteFailed(String)
        case showPopUp(SettingPopUpType)
        case setIsPresentedPopUp(Bool)  // 바인딩용
        case delegate(Delegate)
        
        case failed(String)
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

            // MARK: - 로그아웃
            case .logout:
                // 서버에 세션 종료 통보
                return .publisher {
                  settingService.signOut()
                    .map { _ in .logoutSucceeded }
                    .catch { Just(.logoutFailed($0.localizedDescription)) }
                    .receive(on: DispatchQueue.main)
                }

            case .logoutSucceeded:
                // 로컬 토큰/세션 정리(필요 시)
                tokenProvider.accessToken = nil
                state.popUpType = nil

                return .publisher {
                    authClient.signOut()
                        .map { _ in .delegate(.didLogout) }    // 성공 시 액션 변환
                        .catch { Just(.failed($0.localizedDescription)) }
                        .receive(on: DispatchQueue.main)  // UI 업데이트 안전
                }

            case .logoutFailed(let message):
                print("로그아웃 실패: \(message)")
                return .none

            // MARK: - 탈퇴
            case .delete:
                // 서버에  요청 
                return .publisher {
                  settingService.delete()
                    .map { _ in .deleteSucceeded }
                    .catch { Just(.deleteFailed($0.localizedDescription)) }
                    .receive(on: DispatchQueue.main)
                }
                
            case .deleteSucceeded:
                // 로컬 처리
                tokenProvider.accessToken = nil
                state.popUpType = nil
                
                return .publisher {
                    authClient.deleteUser()
                        .map { _ in .delegate(.didLogout) }    // 성공 시 액션 변환
                        .catch { Just(.failed($0.localizedDescription)) }
                        .receive(on: DispatchQueue.main)  // UI 업데이트 안전
                }

            case .deleteFailed(let error):
                print("회원탈퇴 실패: \(error)")
                return .none
                
            case .failed(let error):
                print("Failed: \(error)")
                return .none
            default: return .none
            }
        }
    }
}

public enum SettingPopUpType: Equatable {
    case logout, delete
}
