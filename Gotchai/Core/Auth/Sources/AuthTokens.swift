//
//  AuthTokens.swift
//  SignIn
//
//  Created by koreamango on 8/13/25.
//

public struct AuthTokens: Equatable, Codable {
    public let accessToken: String
    public let refreshToken: String

    public init(accessToken: String, refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}
