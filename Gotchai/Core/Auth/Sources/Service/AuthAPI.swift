//
//  AuthAPI.swift
//  Auth
//
//  Created by koreamango on 8/17/25.
//

import Moya
import SwiftUI
import CustomNetwork

enum AuthAPI {
    case refresh(token: String)
}

extension AuthAPI: BaseTarget {
    var path: String {
        switch self { case .refresh: return "/auth/refresh" }
    }

    var method: Moya.Method { .post }

    var task: Task {
        switch self {
        case .refresh(let token):
            return .requestJSONEncodable(["refreshToken": token])
        }
    }
}
