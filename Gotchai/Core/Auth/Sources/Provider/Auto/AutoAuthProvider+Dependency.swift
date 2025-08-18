//
//  AutoAuthProvider+Dependency.swift
//  Auth
//
//  Created by koreamango on 8/4/25.
//

import TCA

extension AutoAuthProvider: DependencyKey {
    public static let liveValue: AutoAuthProvider = {
        return AutoAuthProvider()
    }()
}

public extension DependencyValues {
    var autoAuthProvider: AutoAuthProvider {
        get { self[AutoAuthProvider.self] }
        set { self[AutoAuthProvider.self] = newValue }
    }
}
