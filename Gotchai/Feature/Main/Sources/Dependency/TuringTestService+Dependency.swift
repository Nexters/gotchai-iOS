//
//  TuringTestService+Dependency.swift
//  Main
//
//  Created by 가은 on 8/13/25.
//

import TCA
import CustomNetwork

extension TuringTestService: DependencyKey {
    public static let liveValue: TuringTestService = {
        TuringTestService(networkClient: MockNetworkClient())
    }()

    public static func live(_ network: NetworkClient) -> Self {
        .init(networkClient: network)
    }
}

public extension DependencyValues {
     var turingTestService: TuringTestService {
        get { self[TuringTestService.self] }
        set { self[TuringTestService.self] = newValue }
    }
}
