//
//  TuringTestService+Dependency.swift
//  Main
//
//  Created by 가은 on 8/13/25.
//

import TCA

extension TuringTestService: DependencyKey {
    static let liveValue: TuringTestService = {
        TuringTestService(networkClient: DependencyValues.live.networkClient)
    }()
}

extension DependencyValues {
    var turingTestService: TuringTestService {
        get { self[TuringTestService.self] }
        set { self[TuringTestService.self] = newValue }
    }
}
