//
//  SettingService.swift
//  Setting
//
//  Created by koreamango on 8/15/25.
//

import Foundation
import Auth
import CustomNetwork
import TCA
import Combine

public struct SettingService {
    private let networkClient: NetworkClient

    public init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func signOut() -> AnyPublisher<Void, Error> {
        networkClient
            .request(SettingAPI.signOut) // Void 오버로드
    }

    func delete() -> AnyPublisher<String, Error> {
        networkClient.request(SettingAPI.delete, type: String.self)
    }
}
