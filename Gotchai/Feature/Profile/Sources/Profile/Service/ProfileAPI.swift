//
//  ProfileAPI.swift
//  Profile
//
//  Created by 가은 on 8/16/25.
//

import CustomNetwork
import Moya

enum ProfileAPI {
    case getRanking
}

extension ProfileAPI: BaseTarget {
    var path: String {
        switch self {
        case .getRanking:
            return apiPrefix + "/users/me/ranking"
        }
    }
    
    var method: Moya.Method {
        .get
    }
    
    var task: Moya.Task {
        .requestPlain
    }

}
