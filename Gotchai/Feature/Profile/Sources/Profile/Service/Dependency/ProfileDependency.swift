//
//  ProfileDependency.swift
//  Profile
//
//  Created by 가은 on 8/16/25.
//

import TCA
import CustomNetwork

extension ProfileService: DependencyKey {
    public static let liveValue: ProfileService = {
        ProfileService(networkClient: DependencyValues.live.networkClient)
    }()
    
    public static func live(_ network: NetworkClient) -> Self {
        .init(networkClient: network)
    }
}

public extension DependencyValues {
    var profileService: ProfileService {
        get { self[ProfileService.self] }
        set { self[ProfileService.self] = newValue }
    }
}

