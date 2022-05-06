//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/05/06.
//

import Foundation

private let userDefaultsSystemKeys: [String] = [
    "AddingEmojiKeybordHandled",
    "CarCapabilities",
    "MSVLoggingMasterSwitchEnabledKey",
    "PreferredLanguages",
]

private let userDefaultsSystemKeyPrefixes: [String] = [
    "Apple",
    "com.apple.",
    "internalSettings.",
    "METAL_",
    "INNext",
    "AK",
    "NS",
    "PK",
    "WebKit",
]

struct UserDefaultsContainer: Identifiable {
    var id: String { name }

    let name: String
    let defaults: UserDefaults
    let excludeKeys: (String) -> Bool

    var allKeys: [String] {
        Array(
            defaults.dictionaryRepresentation().keys.exclude {
                isOSSKey($0) || excludeKeys($0)
            }
        )
    }

    var systemKeys: [String] {
        allKeys.filter { isSystemKey($0) }
    }

    var userKeys: [String] {
        allKeys.filter { isSystemKey($0) == false }
    }

    func extractKeys(of type: UserDefaultsType) -> [String] {
        switch type {
        case .user: return userKeys
        case .system: return systemKeys
        }
    }

    func removeAll(of type: UserDefaultsType) {
        for key in extractKeys(of: type) {
            defaults.removeObject(forKey: key)
        }
    }

    func lookup(forKey key: String) -> Any? {
        defaults.lookup(forKey: key)
    }

    // MARK: Private

    private func isOSSKey(_ key: String) -> Bool {
        key.hasPrefix(UserDefaults.keyRepository)
    }

    private func isSystemKey(_ key: String) -> Bool {
        userDefaultsSystemKeys.contains(key) ||
            userDefaultsSystemKeyPrefixes.contains { key.hasPrefix($0) }
    }
}
