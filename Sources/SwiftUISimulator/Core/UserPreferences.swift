//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/04/16.
//

import SwiftUI

final class UserPreferences: ObservableObject {
    @Published var device: Device? {
        didSet {
            saveDevice()
        }
    }

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

    @Published var enableTimeZones: Set<TimeZones> {
        didSet {
            saveEnableTimeZones()
        }
    }

    public init(
        defaultDevices: Set<Device>? = nil,
        defaultLocaleIdentifiers: Set<String>? = nil,
        defaultCalendarIdentifiers: Set<Calendar.Identifier>? = nil,
        defaultTimeZones: Set<TimeZones>? = nil
    ) {
        device = Self.loadDevice()

        //
        // 💡 The following priority order.
        //
        // 1. Saved user settings.
        // 2. Specified user settings on SimulatorView's initializer.
        // 3. Default presets.
        //
        enableDevices = Self.loadEnableDevices() ?? defaultDevices ?? Presets.devices
        enableLocales = Self.loadEnableLocales() ?? defaultLocaleIdentifiers ?? Presets.locales
        enableCalendars = Self.loadEnableCalendars() ?? defaultCalendarIdentifiers ?? Presets.calendars
        enableTimeZones = Self.loadEnableTimeZones() ?? defaultTimeZones ?? Presets.timeZones
    }

    private func saveDevice() {
        if let rawValue = device?.id {
            UserDefaults.standard.set(rawValue, forKey: "\(storageKeyPrefix).deviceID")
        } else {
            UserDefaults.standard.removeObject(forKey: "\(storageKeyPrefix).deviceID")
        }
    }

    private static func loadDevice() -> Device? {
        if let rawValue = UserDefaults.standard.string(forKey: "\(storageKeyPrefix).deviceID") {
            return Device(id: rawValue)
        } else {
            return nil
        }
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

    private func saveEnableTimeZones() {
        let rawValues = Array(enableTimeZones.map(\.rawValue))
        UserDefaults.standard.set(rawValues, forKey: "\(storageKeyPrefix).enableTimeZones")
    }

    private static func loadEnableTimeZones() -> Set<TimeZones>? {
        if let rawValues = UserDefaults.standard.stringArray(forKey: "\(storageKeyPrefix).enableTimeZones") {
            return Set(rawValues.compactMap { TimeZones(rawValue: $0) })
        } else {
            return nil
        }
    }
}
