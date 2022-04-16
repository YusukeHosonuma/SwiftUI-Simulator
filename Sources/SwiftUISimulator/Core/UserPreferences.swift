//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/04/16.
//

import SwiftUI

//
// Presets
//
private let devicePresets: Set<Device> = [
    .iPodTouch,
    .iPhoneSE,
    .iPhone11,
    .iPhone13ProMax,
    .iPadMini_5th,
]
private let localeIdentifierPresets: Set<String> = ["en_US", "ja_JP"]
private let calendarIdentifierPresets: Set<Calendar.Identifier> = [.iso8601, .japanese]

final class UserPreferences: ObservableObject {
    @Published var enableDevices: Set<Device> {
        didSet {
            saveEnableDevices()
        }
    }

    @Published var enableLocales: Set<String> {
        didSet {
            saveEnableLocales()
        }
    }

    @Published var enableCalendars: Set<Calendar.Identifier> {
        didSet {
            saveEnableCalendars()
        }
    }

    public init(
        defaultDevices: Set<Device>? = nil,
        defaultLocaleIdentifiers: Set<String>? = nil,
        defaultCalendarIdentifiers: Set<Calendar.Identifier>? = nil
    ) {
        enableDevices = defaultDevices ?? Self.loadEnableDevices() ?? devicePresets
        enableLocales = defaultLocaleIdentifiers ?? Self.loadEnableLocales() ?? localeIdentifierPresets
        enableCalendars = defaultCalendarIdentifiers ?? Self.loadEnableCalendars() ?? calendarIdentifierPresets
    }

    private func saveEnableDevices() {
        let rawValues = Array(enableDevices.map(\.id))
        UserDefaults.standard.set(rawValues, forKey: "\(storageKeyPrefix).enableDevices")
    }

    private static func loadEnableDevices() -> Set<Device>? {
        if let rawValues = UserDefaults.standard.stringArray(forKey: "\(storageKeyPrefix).enableDevices") {
            return Set(rawValues.compactMap { Device(id: $0) })
        } else {
            return nil
        }
    }

    private func saveEnableLocales() {
        UserDefaults.standard.set(Array(enableLocales), forKey: "\(storageKeyPrefix).enableLocales")
    }

    private static func loadEnableLocales() -> Set<String>? {
        if let identifiers = UserDefaults.standard.stringArray(forKey: "\(storageKeyPrefix).enableLocales") {
            return Set(identifiers)
        } else {
            return nil
        }
    }

    private func saveEnableCalendars() {
        UserDefaults.standard.set(Array(enableCalendars.map(\.rawValue)), forKey: "\(storageKeyPrefix).enableCalendars")
    }

    private static func loadEnableCalendars() -> Set<Calendar.Identifier>? {
        if let rawValues = UserDefaults.standard.stringArray(forKey: "\(storageKeyPrefix).enableCalendars") {
            return Set(rawValues.compactMap(Calendar.Identifier.init))
        } else {
            return nil
        }
    }
}
