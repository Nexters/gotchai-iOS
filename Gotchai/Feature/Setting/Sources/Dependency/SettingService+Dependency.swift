//
//  SettingService+Dependency.swift
//  Setting
//
//  Created by koreamango on 8/15/25.
//

import TCA
import CustomNetwork

extension SettingService: DependencyKey {
    public static let liveValue: SettingService = {
        SettingService(networkClient: MockNetworkClient())
    }()

    public static func live(_ network: NetworkClient) -> Self {
        .init(networkClient: network)
    }
}

public extension DependencyValues {
    var settingService: SettingService {
        get { self[SettingService.self] }
        set { self[SettingService.self] = newValue }
    }
}
