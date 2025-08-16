//
//  SolvedTuringTestService+Dependency.swift
//  Profile
//
//  Created by koreamango on 8/16/25.
//

import TCA
import CustomNetwork

extension SolvedTuringTestService: DependencyKey {
    public static let liveValue: SolvedTuringTestService = {
        SolvedTuringTestService(networkClient: MockNetworkClient())
    }()
}

public extension DependencyValues {
    var solvedTuringTestService: SolvedTuringTestService {
        get { self[SolvedTuringTestService.self] }
        set { self[SolvedTuringTestService.self] = newValue }
    }
}
