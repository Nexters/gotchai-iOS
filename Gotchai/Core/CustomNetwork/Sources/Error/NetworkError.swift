//
//  NetworkError.swift
//  Network
//
//  Created by koreamango on 7/20/25.
//

enum NetworkError: Error {
    case RequestError(code: Int, message: String)
    case DecodeError(code: Int, message: String)
}
