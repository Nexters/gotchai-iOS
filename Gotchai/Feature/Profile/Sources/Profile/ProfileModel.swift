//
//  ProfileModel.swift
//  Profile
//
//  Created by 가은 on 8/16/25.
//

public struct Profile {
    let nickname: String
    let rating: Int
    
    public init(nickname: String, rating: Int) {
        self.nickname = nickname
        self.rating = rating
    }
}
