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
]

extension UserDefaults {
    var systemKeys: [String] {
        allKeys.filter(isSystemKey)
    }

    var userKeys: [String] {
        allKeys.filter { isSystemKey($0) == false }
    }

    private var allKeys: Dictionary<String, Any>.Keys {
        dictionaryRepresentation().keys
    }

    private func isSystemKey(_ key: String) -> Bool {
        userDefaultsSystemKeys.contains(key) ||
            userDefaultsSystemKeyPrefixes.matchAny { key.hasPrefix($0) }
    }
}
