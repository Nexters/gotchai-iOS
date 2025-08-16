//
//  NetworkError.swift
//  Network
//
//  Created by koreamango on 7/20/25.
//

public enum NetworkError: Error {
    case Unauthorized
    case RequestError(code: String, message: String)
    case DecodeError(code: String, message: String)
}
