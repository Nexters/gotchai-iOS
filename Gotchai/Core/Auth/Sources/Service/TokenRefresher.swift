//
//  TokenRefresher.swift
//  CustomNetwork
//
//  Created by koreamango on 8/17/25.
//

import CustomNetwork
import Common
import Combine
import Foundation
import Moya

public final class TokenRefresher: TokenRefresherProtocol {
    private let provider: MoyaProvider<MultiTarget>
    private let tokenStore: TokenProvider
    private let lock = NSLock()
    private var inFlight: AnyPublisher<Void, Error>?

    public var onRefreshFailed: (() -> Void)?

    public init(provider: MoyaProvider<MultiTarget>, tokenStore: TokenProvider) {
        self.provider = provider
        self.tokenStore = tokenStore
    }

    public func shouldRefresh(for error: Error) -> Bool {
        // 서비스 규격에 맞게 판정
        // 1) HTTP 401
        if case NetworkError.RequestError(let errorCode, _) = error,
           errorCode == "UNAUTHENTICATED_USER" {
            return true
        }
        // 2) 서버 에러 DTO의 토큰 만료 코드
        if let e = error as? ErrorResponseDTO {
            return e.errorCode == "UNAUTHENTICATED_USER"
        }
        return false
    }

    public func refreshIfNeeded() -> AnyPublisher<Void, Error> {
        guard let rt = tokenStore.refreshToken, !rt.isEmpty else {
            return Fail(error: NetworkError.Unauthorized).eraseToAnyPublisher()
        }

        lock.lock()
        if let ongoing = inFlight { lock.unlock(); return ongoing }
        lock.unlock()

        let pub = provider.requestPublisher(MultiTarget(AuthAPI.refresh(token: rt)))
            .tryMap { response -> AuthTokens in
                guard (200..<300).contains(response.statusCode) else {
                    throw NetworkError.Unauthorized
                }
                return try JSONDecoder().decode(AuthTokens.self, from: response.data)
            }
            .map { [weak self] tokens in
                self?.tokenStore.accessToken = tokens.accessToken
                self?.tokenStore.refreshToken = tokens.refreshToken
            }
            .handleEvents(receiveCompletion: { [weak self] completion in
                guard let self else { return }
                self.lock.lock(); self.inFlight = nil; self.lock.unlock()
                if case .failure = completion { self.onRefreshFailed?() }
            })
            .share()
            .eraseToAnyPublisher()

        lock.lock(); inFlight = pub; lock.unlock()
        return pub
    }
}
