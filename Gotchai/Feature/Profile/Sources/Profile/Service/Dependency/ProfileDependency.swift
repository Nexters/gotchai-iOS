//
//  ProfileDependency.swift
//  Profile
//
//  Created by 가은 on 8/16/25.
//

import TCA

extension ProfileService: DependencyKey {
    static let liveValue: ProfileService = {
        ProfileService(networkClient: DependencyValues.live.networkClient)
    }()
}

extension DependencyValues {
    var profileService: ProfileService {
        get { self[ProfileService.self] }
        set { self[ProfileService.self] = newValue }
    }
}

