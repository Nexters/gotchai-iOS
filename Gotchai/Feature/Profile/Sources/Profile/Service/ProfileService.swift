//
//  ProfileService.swift
//  Profile
//
//  Created by 가은 on 8/16/25.
//

import CustomNetwork
import Combine

public struct ProfileService {
    private let networkClient: NetworkClient
    
    public init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    public func getRanking() -> AnyPublisher<Profile, Error> {
        networkClient
            .request(ProfileAPI.getRanking, type: RankingResponseDTO.self)
            .map { dto in
                Profile(nickname: dto.name, rating: dto.rating)
            }
            .eraseToAnyPublisher()
    }
}
