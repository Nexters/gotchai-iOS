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
    private let refresher: TokenRefresherProtocol

    public init(provider: MoyaProvider<MultiTarget>, refresher: TokenRefresherProtocol) {
        self.provider = provider
        self.refresher = refresher
    }

    // 에러가 "만료"인지 판단하는 헬퍼
    private func shouldRefresh(for error: Error) -> Bool {
        if case NetworkError.Unauthorized = error { return true }
        if let err = error as? ErrorResponseDTO {
            // 서버 정의된 만료 코드로 교체
            return err.errorCode == "401"
        }
        if case NetworkError.RequestError(let code, _) = error, code == 401 { return true }
        return false
    }

    private func decodeAPI<T: Decodable>(_ response: Response, as type: T.Type) throws -> T {
        guard (200..<300).contains(response.statusCode) else {
            if let errorResponse = try? JSONDecoder().decode(APIResponse<ErrorResponseDTO>.self, from: response.data) {
                throw ErrorResponseDTO(errorCode: errorResponse.data.errorCode, message: errorResponse.data.message)
            }
            throw NetworkError.RequestError(code: response.statusCode, message: response.description)
        }

        let decoded = try JSONDecoder().decode(APIResponse<T>.self, from: response.data)
        guard decoded.isSuccess else {
            if let errorResponse = try? JSONDecoder().decode(APIResponse<ErrorResponseDTO>.self, from: response.data) {
                throw ErrorResponseDTO(errorCode: errorResponse.data.errorCode, message: errorResponse.data.message)
            }
            throw NetworkError.DecodeError(code: 9999, message: "Decode 오류가 발생했습니다.")
        }
        return decoded.data
    }

    // 원요청 한 번 실행
    private func rawRequest<T: Decodable>(_ target: any Moya.TargetType, type: T.Type) -> AnyPublisher<T, Error> {
        return provider
            .requestPublisher(MultiTarget(target))
            .handleEvents(receiveOutput: { response in
                #if DEBUG
                print("🔵 RAW:", String(data: response.data, encoding: .utf8) ?? "nil")
                #endif
            })
            .tryMap { [weak self] response in
                guard let self = self else { throw NetworkError.DecodeError(code: -1, message: "Deallocated") }
                return try self.decodeAPI(response, as: T.self)
            }
            .eraseToAnyPublisher()
    }

    public func request<T: Decodable>(
        _ target: any Moya.TargetType,
        type: T.Type
    ) -> AnyPublisher<T, any Error> {
        return rawRequest(target, type: T.self)
            .catch { [weak self] error -> AnyPublisher<T, Error> in
                guard let self, refresher.shouldRefresh(for: error) else {
                    return Fail(error: error).eraseToAnyPublisher()
                }
                return refresher.refreshIfNeeded()
                    .flatMap { self.rawRequest(target, type: T.self) }
                    .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    public func request(_ target: TargetType) -> AnyPublisher<Void, Error> {
        func rawVoid() -> AnyPublisher<Void, Error> {
            return provider.requestPublisher(MultiTarget(target))
                .tryMap { try $0.filterSuccessfulStatusCodes(); return () }
                .eraseToAnyPublisher()
        }

        return rawVoid()
            .catch { [weak self] error -> AnyPublisher<Void, Error> in
                guard let self, refresher.shouldRefresh(for: error) else {
                    return Fail(error: error).eraseToAnyPublisher()
                }
                return refresher.refreshIfNeeded()
                    .flatMap { rawVoid() }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
