//
//  AuthClient+Live.swift
//  Auth
//
//  Created by 가은 on 7/23/25.
//

import TCA
import Combine

extension AuthClient: DependencyKey {
    public static func live(runtime: AuthRuntime = AuthRuntime()) -> AuthClient {
        AuthClient(
            signIn: { provider in
                provider.signIn()
                    .handleEvents(receiveOutput: { session in
                        runtime.set(session: session, provider: provider)
                    })
                    .eraseToAnyPublisher()
            },
            signOut: {
                Result { () -> AuthProvider in
                    guard let provider = runtime.provider() else { throw AuthError.noActiveProvider }
                    return provider
                }
                .publisher
                .flatMap { provider in
                    provider.signOut()
                        .handleEvents(receiveCompletion: { completion in
                            if case .finished = completion { runtime.clear() }
                        })
                }
                .eraseToAnyPublisher()
            },
            deleteUser: {
                Result { () -> AuthProvider in
                    guard let provider = runtime.provider() else { throw AuthError.noActiveProvider }
                    return provider
                }
                .publisher
                .flatMap { provider in
                    provider.deleteUser()
                        .handleEvents(receiveCompletion: { completion in
                            if case .finished = completion { runtime.clear() }
                        })
                }
                .eraseToAnyPublisher()
            }
        )
    }
    
    public static let liveValue: AuthClient = .live()
}


public extension DependencyValues {
    var authClient: AuthClient {
        get { self[AuthClient.self] }
        set { self[AuthClient.self] = newValue }
    }
}
