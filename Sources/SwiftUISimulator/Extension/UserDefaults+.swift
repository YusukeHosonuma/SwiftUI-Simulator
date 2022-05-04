//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/05/01.
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

enum UserDefaultsType {
    case user
    case system
}

struct JSONData {
    let dictionary: [String: Any]
}

extension UserDefaults {
    var systemKeys: [String] {
        allKeys.filter { isSystemKey($0) }
    }

    var userKeys: [String] {
        allKeys.filter { isSystemKey($0) == false }
    }

    var allKeys: [String] {
        Array(
            dictionaryRepresentation().keys.filter { isOSSKey($0) == false }
        )
    }

    func extractKeys(of type: UserDefaultsType) -> [String] {
        switch type {
        case .user: return userKeys
        case .system: return systemKeys
        }
    }

    func lookup(forKey key: String) -> Any? {
        if let _ = value(forKey: key) as? Data, let url = url(forKey: key) {
            return url
        }

        if let dict = dictionary(forKey: key) {
            return dict
        }

        if let data = data(forKey: key),
           let decoded = try? JSONSerialization.jsonObject(with: data),
           let dict = decoded as? [String: Any]
        {
            return JSONData(dictionary: dict)
        }

        return value(forKey: key)
    }

    private func isOSSKey(_ key: String) -> Bool {
        key.hasPrefix(storageKeyPrefix)
    }

    private func isSystemKey(_ key: String) -> Bool {
        userDefaultsSystemKeys.contains(key) ||
            userDefaultsSystemKeyPrefixes.contains { key.hasPrefix($0) }
    }
}
