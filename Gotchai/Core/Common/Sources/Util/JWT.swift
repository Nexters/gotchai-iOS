//
//  JWT.swift
//  Common
//
//  Created by koreamango on 8/17/25.
//

import Foundation

public func isJWTExpired(_ token: String) -> Bool {
    // 매우 러프한 디코더 (에러 시 false 반환)
    let parts = token.split(separator: ".")
    guard parts.count >= 2,
          let payloadData = Data(base64Encoded: String(parts[1])
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
            .padding(toLength: ((String(parts[1]).count+3)/4)*4, withPad: "=", startingAt: 0)),
          let json = try? JSONSerialization.jsonObject(with: payloadData) as? [String: Any],
          let exp = json["exp"] as? TimeInterval
    else { return false }
    return Date().timeIntervalSince1970 >= exp
}
