//
//  AuthProvider.swift
//  Auth
//
//  Created by koreamango on 8/14/25.
//

import Combine

public enum AuthProviderKind: Equatable, Sendable { case kakao, apple, auto }

public protocol AuthProvider: Sendable {
    var kind: AuthProviderKind { get }
    func signIn() -> AnyPublisher<UserSession, Error>
    func signOut() -> AnyPublisher<Void, Error>
    func deleteUser() -> AnyPublisher<Void, Error>
}

