//
//  ResponseDTO.swift
//  Profile
//
//  Created by koreamango on 8/15/25.
//

import Foundation

public struct BadgeListResponseDTO: Decodable, Equatable, Sendable {
    public let badges: [BadgeDTO]
    public let totalBadgeCount: Int
}

public struct BadgeDTO: Decodable, Equatable, Sendable {
    public let id: Int
    public let name: String
    public let image: String
    public let acquiredAt: String
}
