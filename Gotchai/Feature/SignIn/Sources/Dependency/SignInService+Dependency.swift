//
//  SignInService+Dependency.swift
//  SignIn
//
//  Created by koreamango on 8/9/25.
//


import TCA
import CustomNetwork

extension SignInService: DependencyKey {
    public static let liveValue: SignInService = {
        SignInService(networkClient: MockNetworkClient())
    }()

    public static func live(_ network: NetworkClient) -> Self {
        .init(networkClient: network)
    }
}

public extension DependencyValues {
    var signInService: SignInService {
        get { self[SignInService.self] }
        set { self[SignInService.self] = newValue }
    }
}
