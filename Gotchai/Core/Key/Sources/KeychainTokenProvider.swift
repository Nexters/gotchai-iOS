//
//  KeychainTokenProvider.swift
//  Key
//
//  Created by koreamango on 7/20/25.
//

import Foundation
import Security
import Common

public final class KeychainTokenProvider: TokenProvider {
    public static let shared = KeychainTokenProvider()

    private let service = "com.gotchai.token"

    private enum AccountType: String {
        case accessAccount, refreshAccount
    }

    private init() {}

    public var accessToken: String? {
        get {
            guard let data = readKeychain(.accessAccount) else { return nil }
            return String(data: data, encoding: .utf8)
        }
        set {
            if let newToken = newValue {
                saveKeychain(.accessAccount, data: Data(newToken.utf8))
            } else {
                deleteKeychain(.accessAccount)
            }
        }
    }

    public var refreshToken: String? {
        get {
            guard let data = readKeychain(.refreshAccount) else { return nil }
            return String(data: data, encoding: .utf8)
        }
        set {
            if let newToken = newValue {
                saveKeychain(.refreshAccount, data: Data(newToken.utf8))
            } else {
                deleteKeychain(.refreshAccount)
            }
        }
    }

    private func readKeychain(_ account: AccountType) -> Data? {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account.rawValue,
            kSecReturnData: true
        ]

        var result: AnyObject?
        SecItemCopyMatching(query as CFDictionary, &result)
        return result as? Data
    }

    private func saveKeychain(_ account: AccountType, data: Data) {
        deleteKeychain(account)

        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account.rawValue,
            kSecValueData: data
        ]

        SecItemAdd(query as CFDictionary, nil)
    }

    private func deleteKeychain(_ account: AccountType) {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account.rawValue
        ]
        SecItemDelete(query as CFDictionary)
    }
}
