//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/04/21.
//

import Defaults
import SwiftUI

// 💡 Please update version number when data incompatibility occur.
private let prefix = "YusukeHosonuma/SwiftUI-Simulator/1.3.0"

extension Defaults.Keys {
    //
    // Device and appearance
    //
    static let device = Key<Device?>("\(prefix).device", default: nil)
    static let isDark = Key<Bool>("\(prefix).isDark", default: false)
    static let isDualMode = Key<Bool>("\(prefix).isDualMode", default: false)
    static let isPortrait = Key<Bool>("\(prefix).isPortrait", default: true)

    //
    // Presets
    //
    static let enableDevices = Key<Set<Device>>("\(prefix).enableDevices", default: [])
    static let enableLocales = Key<Set<String>>("\(prefix).enableLocales", default: [])
    static let enableCalendars = Key<Set<Calendar.Identifier>>("\(prefix).enableCalendars", default: [])
    static let enableTimeZones = Key<Set<TimeZones>>("\(prefix).enableTimeZones", default: [])

    //
    // Fonts
    //
    static let legibilityWeight = Key<LegibilityWeight>("\(prefix).legibilityWeight", default: .regular)
    static let dynamicTypeSize = Key<DynamicTypeSizeWrapper>("\(prefix).dynamicTypeSize", default: .medium)
    static let isDynamicTypeSizesEnabled = Key<Bool>("\(prefix).isDynamicTypeSizesEnabled", default: true)

    //
    // International
    //
    static let locale = Key<String?>("\(prefix).locale", default: nil)
    static let calendar = Key<Calendar.Identifier?>("\(prefix).calendar", default: nil)
    static let timeZone = Key<TimeZones>("\(prefix).timeZone", default: .current)

    //
    // Debug information
    //
    static let isDisplayInformation = Key<Bool>("\(prefix).isDisplayInformation", default: true)
    static let isDisplaySafeArea = Key<Bool>("\(prefix).isDisplaySafeArea", default: true)

    //
    // Simultor state
    //
    static let isSimulatorEnabled = Key<Bool>("\(prefix).isSimulatorEnabled", default: true)
    static let isDisplayCheetSheet = Key<Bool>("\(prefix).isDisplayCheetSheet", default: false)
    static let isHiddenControl = Key<Bool>("\(prefix).isHiddenControl", default: false)

    //
    // Simulator appearance
    //
    static let simulatorAccentColor = Key<ColorWrapper>("\(prefix).simulatorAccentColor", default: ColorWrapper(.defaultSimulatorAccent))
    static let simulatorBorderColor = Key<ColorWrapper>("\(prefix).simulatorBorderColor", default: ColorWrapper(.defaultSimulatorBorder))
    static let simulatorSafeAreaColor = Key<ColorWrapper>("\(prefix).simulatorSafeAreaColor", default: ColorWrapper(.defaultSimulatorSafeArea))

    //
    // Setting view
    //
    static let isExpandedDevice = Key<Bool>("\(prefix).Setting.isExpandedDevice", default: false)
    static let isExpandedLocale = Key<Bool>("\(prefix).Setting.isExpandedLocale", default: false)
    static let isExpandedCalendar = Key<Bool>("\(prefix).Setting.isExpandedCalendar", default: false)
    static let isExpandedTimeZone = Key<Bool>("\(prefix).Setting.isExpandedTimeZone", default: false)
    static let isExpandedSimulator = Key<Bool>("\(prefix).Setting.isExpandedSimulator", default: false)
}

extension ColorWrapper: Defaults.Serializable {}
extension Device: Defaults.Serializable {}
extension LegibilityWeight: Defaults.Serializable {}
extension DynamicTypeSizeWrapper: Defaults.Serializable {}
extension Calendar.Identifier: Defaults.Serializable {}
extension TimeZones: Defaults.Serializable {}
