//
//  ErrorResponseDTO.swift
//  Network
//
//  Created by koreamango on 8/7/25.
//

public struct ErrorResponseDTO: Decodable, Error {
  public let errorCode: String
  public let message: String
}
