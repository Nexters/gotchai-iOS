//
//  AutoAuthProvider.swift
//  Auth
//
//  Created by koreamango on 8/17/25.
//

import Combine
import Key
import Common

public final class AutoAuthProvider: AuthProvider {
    public var kind: AuthProviderKind

    init() {
        self.kind = .auto
    }

    public func signIn() -> AnyPublisher<UserSession, any Error> {
        let access = KeychainTokenProvider.shared.accessToken

        guard let access, !isJWTExpired(access) else  {
            return Fail(error: AuthError.signInFailed(reason: "Access Token이 없음"))
                .eraseToAnyPublisher()
        }

        var session = UserSession(id: "", name: "", email: "", token: access)
        return Just((session))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()

    }

    public func signOut() -> AnyPublisher<Void, any Error> {
        Just(())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    public func deleteUser() -> AnyPublisher<Void, any Error> {
        Just(())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

}
