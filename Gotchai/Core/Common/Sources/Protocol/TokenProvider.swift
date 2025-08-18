//
//  TokenProvider.swift
//  Common
//
//  Created by koreamango on 7/20/25.
//

public protocol TokenProvider: AnyObject {
    var accessToken: String? { get set }
    var refreshToken: String? { get set }
}
