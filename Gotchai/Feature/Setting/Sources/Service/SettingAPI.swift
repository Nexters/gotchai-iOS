//
//  SettingAPI.swift
//  Setting
//
//  Created by koreamango on 8/15/25.
//

import CustomNetwork
import Auth
import Moya

enum SettingAPI {
    case signOut
    case delete
}

extension SettingAPI: BaseTarget {
    var path: String {
        switch self {
        case .signOut:
            return apiPrefix + "/auth/logout"
        case .delete:
            return apiPrefix + "/auth/withdrawal"
        }
    }

    var method: Moya.Method {
        switch self {
        case .signOut: return .post
        case .delete: return .delete
        }
    }

    var task: Task {
        switch self {
        case .signOut:
            return .requestPlain
        case .delete:
            return .requestPlain
        }
    }
}
