//
//  NetworkClient+Dependency.swift
//  CustomNetwork
//
//  Created by koreamango on 8/17/25.
//

import TCA

extension MoyaAPIClient: DependencyKey {
    public static let liveValue: NetworkClient = {
        MockNetworkClient()
    }()
}

public extension DependencyValues {
    var networkClient: NetworkClient {
        get { self[MoyaAPIClient.self] }
        set { self[MoyaAPIClient.self] = newValue }
    }
}
