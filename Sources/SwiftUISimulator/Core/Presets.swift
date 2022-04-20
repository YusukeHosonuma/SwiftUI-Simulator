//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/04/20.
//

import Foundation

final class Presets {
    static let devices: Set<Device> = [
        .iPodTouch,
        .iPhoneSE,
        .iPhone11,
        .iPhone13ProMax,
        .iPadMini_5th,
    ]

    static let locales: Set<String> = ["en_US", "ja_JP"]

    static let calendars: Set<Calendar.Identifier> = [.iso8601, .japanese]

    static let timeZones: Set<TimeZones> = [
        .asiaTokyo,
        .americaNewYork,
    ]
}
