//
//  BadgeModel.swift
//  Profile
//
//  Created by 가은 on 8/9/25.
//

import Foundation

public struct Badge: Equatable {
    let id: Int
    let imageURL: String
    let name: String
    let acquiredAt: String

    init(id: Int, imageURL: String, name: String, acquiredAt: String) {
        self.id = id
        self.imageURL = imageURL
        self.name = name
        self.acquiredAt = acquiredAt
    }
}

// 1) DTO → Domain 매핑
public extension Badge {
    init(dto: BadgeDTO) {
        // id는 클라에서 UUID 생성, 서버 id가 필요하면 모델을 바꾸세요
        self.init(
            id: dto.id,
            imageURL: dto.image,
            name: dto.name,
            acquiredAt: dto.acquiredAt
        )
    }
}

enum BadgeListError: LocalizedError {
    case server(status: Int)
    var errorDescription: String? {
        switch self {
        case .server(let code):
            return "Badge API failed (status: \(code))"
        }
    }
}
