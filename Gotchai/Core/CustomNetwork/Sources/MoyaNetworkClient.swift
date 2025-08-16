//
//  MoyaNetworkClient.swift
//  Network
//
//  Created by koreamango on 7/20/25.
//


import Foundation
import Moya
import Combine
import CombineMoya

public final class MoyaAPIClient: NetworkClient {
    private let provider: MoyaProvider<MultiTarget>

    public init(provider: MoyaProvider<MultiTarget>) {
        self.provider = provider
    }

    public func request<T: Decodable>(
        _ target: any Moya.TargetType,
        type: T.Type
    ) -> AnyPublisher<T, any Error> {
        provider
            .requestPublisher(MultiTarget(target))
            .handleEvents(receiveOutput: { response in
              #if DEBUG
              print("🔵 RAW:", String(data: response.data, encoding: .utf8) ?? "nil")
              #endif
            })
            .tryMap { response in
                guard (200 ..< 300).contains(response.statusCode) else {
                    if let errorResponse = try? JSONDecoder().decode(APIResponse<ErrorResponseDTO>.self, from: response.data) {
                        throw ErrorResponseDTO.init(
                            errorCode: errorResponse.data.errorCode,
                            message: errorResponse.data.message
                        )
                    }
                    throw NetworkError
                        .RequestError(
                            code: response.statusCode,
                            message: response.description)
                }

                let decoded = try JSONDecoder().decode(APIResponse<T>.self, from: response.data)

                guard decoded.isSuccess else {
                    if let errorResponse = try? JSONDecoder().decode(APIResponse<ErrorResponseDTO>.self, from: response.data) {
                        throw ErrorResponseDTO.init(
                            errorCode: errorResponse.data.errorCode,
                            message: errorResponse.data.message
                        )
                    }
                    throw NetworkError
                        .DecodeError(code: 9999, message: "Decode 오류가 발생했습니다.")
                }

                return decoded.data
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    public func request(_ target: TargetType) -> AnyPublisher<Void, Error> {
        provider.requestPublisher(MultiTarget(target))
            .tryMap { response in
                try response.filterSuccessfulStatusCodes()
                return ()
            }
            .eraseToAnyPublisher()
    }
}
