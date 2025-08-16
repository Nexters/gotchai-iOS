//
//  NetworkError.swift
//  Network
//
//  Created by koreamango on 7/20/25.
//

public enum NetworkError: Error {
    case Unauthorized
    case RequestError(code: Int, message: String)
    case DecodeError(code: Int, message: String)
}
