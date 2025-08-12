//
//  AuthPlugin.swift
//  Network
//
//  Created by koreamango on 7/20/25.
//

import Foundation
import Moya
import Security
import Key

/// 요청 전 Token을 넣어주는 Plugin
public final class AuthPlugin: PluginType {
    public init() {}
    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        guard let token = KeychainTokenProvider.shared.accessToken else { return request }
        var req = request
        req.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return req
    }
}
