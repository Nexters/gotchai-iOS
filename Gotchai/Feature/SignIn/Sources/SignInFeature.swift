//
//  AuthFeature.swift
//  Auth
//
//  Created by 가은 on 7/20/25.
//

import TCA
import Auth
import Combine
import Foundation
import Key
@Reducer
public struct SignInFeature {
    @Dependency(\.kakaoAuthProvider) var kakaoAuthProvider
    @Dependency(\.appleAuthProvider) var appleAuthProvider
    @Dependency(\.authClient) var authClient
    @Dependency(\.signInService) var signInService
    @Dependency(\.tokenProvider) var tokenProvider

    enum CancelID { case signIn, registerSession }
    enum Provider: Equatable { case kakao, apple }

    @ObservableState
    public struct State: Equatable {
        public init() { }
        var isLoading: Bool = false
        var user: UserSession?
        var lastProvider: Provider? = nil
    }

    public enum Delegate { case didSignIn }

    public enum Action {
        case tappedKakaoLogin
        case tappedAppleLogin
        case signInResponse(Result<UserSession, Error>)
        case registerSessionResponse(Result<AuthTokens, Error>)
        case delegate(Delegate)
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                // MARK: - Kakao
            case .tappedKakaoLogin:
                state.isLoading = true
                state.lastProvider = .kakao
                return .publisher {
                    authClient.signIn(kakaoAuthProvider)
                        .receive(on: DispatchQueue.main)
                        .map { SignInFeature.Action.signInResponse(.success($0)) }
                        .catch { Just(.signInResponse(.failure($0))) }
                }
                .cancellable(id: CancelID.signIn, cancelInFlight: true)

                // MARK: - Apple
            case .tappedAppleLogin:
                state.isLoading = true
                state.lastProvider = .apple
                return .publisher {
                    authClient.signIn(appleAuthProvider)
                        .map { .signInResponse(.success($0)) }
                        .receive(on: DispatchQueue.main)
                        .catch { Just(.signInResponse(.failure($0))) }
                }
                .cancellable(id: CancelID.signIn, cancelInFlight: true)

                // MARK: - signIn 결과
            case let .signInResponse(.success(session)):
                state.user = session
                switch state.lastProvider {
                case .kakao:
                    let req = KakaoSignInRequestDTO(accessToken: session.token)
                    return .publisher {
                        signInService.registerKakaoSession(req)
                            .receive(on: DispatchQueue.main)
                            .map { SignInFeature.Action.registerSessionResponse(.success($0)) }
                            .catch { Just(.registerSessionResponse(.failure($0))) }
                    }
                    .cancellable(id: CancelID.registerSession, cancelInFlight: true)

                case .apple:
                    let req = AppleSignInRequestDTO(idToken: session.token)
                    return .publisher {
                        signInService.registerAppleSession(req)
                            .receive(on: DispatchQueue.main)
                            .map { SignInFeature.Action.registerSessionResponse(.success($0)) }
                            .catch { Just(.registerSessionResponse(.failure($0))) }
                    }
                    .cancellable(id: CancelID.registerSession, cancelInFlight: true)

                case .none:
                    state.isLoading = false
                    return .none
                }

            case let .signInResponse(.failure(error)):
                state.isLoading = false
                print("로그인 실패:", error)
                return .none

                // MARK: - 세션 등록 결과
            case let .registerSessionResponse(.success(tokens)):
                tokenProvider.accessToken = tokens.accessToken
                tokenProvider.refreshToken = tokens.refreshToken
                state.isLoading = false
                return .send(.delegate(.didSignIn))

            case let .registerSessionResponse(.failure(error)):
                state.isLoading = false
                print("세션 등록 실패:", error)
                return .none

            case .delegate:
                return .none
            }
        }
    }
}
