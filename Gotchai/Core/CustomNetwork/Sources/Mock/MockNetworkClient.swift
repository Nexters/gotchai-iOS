//
//  MockNetworkClient.swift
//  CustomNetwork
//
//  Created by koreamango on 8/17/25.
//

//  MockNetworkClient.swift
//  Tests support (or in a TestUtils target)

import Foundation
import Combine
import Moya
@testable import Network // or your module where NetworkClient lives

public final class MockNetworkClient: NetworkClient {

    // MARK: - Types
    public struct Key: Hashable, CustomStringConvertible {
        public let baseURL: String
        public let path: String
        public let method: Moya.Method

        public init(target: TargetType) {
            self.baseURL = target.baseURL.absoluteString
            self.path = target.path
            self.method = target.method
        }

        public var description: String { "[\(method.rawValue)] \(baseURL)\(path)" }
    }

    public enum MockError: Error, LocalizedError {
        case missingStub(Key)
        case decodingFailed(Key, underlying: Error)

        public var errorDescription: String? {
            switch self {
            case .missingStub(let key):
                return "No stub registered for \(key)"
            case .decodingFailed(let key, let underlying):
                return "Decoding failed for \(key): \(underlying)"
            }
        }
    }

    // MARK: - Storage
    private var decodableStubs: [Key: Result<Data, Error>] = [:]
    private var voidStubs: [Key: Result<Void, Error>] = [:]

    public private(set) var recordedKeys: [Key] = []
    public var decoder: JSONDecoder = .init()

    public init() {}

    // MARK: - NetworkClient
    public func request<T: Decodable>(_ target: TargetType, type: T.Type) -> AnyPublisher<T, Error> {
        let key = Key(target: target)
        recordedKeys.append(key)

        // 1) 우선 등록된 스텁 확인
        if let result = decodableStubs[key] {
            switch result {
            case .success(let data):
                do {
                    let value = try decoder.decode(T.self, from: data)
                    return Just(value).setFailureType(to: Error.self).eraseToAnyPublisher()
                } catch {
                    return Fail(error: MockError.decodingFailed(key, underlying: error)).eraseToAnyPublisher()
                }
            case .failure(let error):
                return Fail(error: error).eraseToAnyPublisher()
            }
        }

        // 2) 등록이 없으면 target.sampleData를 시도 (편의)
        let data = target.sampleData
        if !data.isEmpty {
            do {
                let value = try decoder.decode(T.self, from: data)
                return Just(value).setFailureType(to: Error.self).eraseToAnyPublisher()
            } catch {
                return Fail(error: MockError.decodingFailed(key, underlying: error)).eraseToAnyPublisher()
            }
        }

        // 3) 그래도 없으면 실패
        return Fail(error: MockError.missingStub(key)).eraseToAnyPublisher()
    }

    public func request(_ target: TargetType) -> AnyPublisher<Void, Error> {
        let key = Key(target: target)
        recordedKeys.append(key)

        if let result = voidStubs[key] {
            return result.publisher.eraseToAnyPublisher()
        }
        return Fail(error: MockError.missingStub(key)).eraseToAnyPublisher()
    }

    // MARK: - Helpers (등록)
    /// Decodable 응답을 Data로 직접 스텁
    public func stubDecodableData(_ data: Data, for target: TargetType) {
        let key = Key(target: target)
        decodableStubs[key] = .success(data)
    }

    /// Decodable 응답을 Encodable 값으로 스텁(내부에서 JSON 인코딩)
    public func stubDecodableValue<E: Encodable>(_ value: E, for target: TargetType, encoder: JSONEncoder = .init()) {
        do {
            let data = try encoder.encode(value)
            stubDecodableData(data, for: target)
        } catch {
            decodableStubs[Key(target: target)] = .failure(error)
        }
    }

    /// Decodable 요청 실패 스텁
    public func stubDecodableError(_ error: Error, for target: TargetType) {
        decodableStubs[Key(target: target)] = .failure(error)
    }

    /// Void 성공/실패 스텁
    public func stubVoidSuccess(for target: TargetType) {
        voidStubs[Key(target: target)] = .success(())
    }

    public func stubVoidError(_ error: Error, for target: TargetType) {
        voidStubs[Key(target: target)] = .failure(error)
    }

    // MARK: - Inspect
    public func reset() {
        decodableStubs.removeAll()
        voidStubs.removeAll()
        recordedKeys.removeAll()
    }
}
