//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/04/10.
//

import SwiftUI

public enum Device: Int, CaseIterable, Comparable {
    public static func < (lhs: Device, rhs: Device) -> Bool {
        lhs.rawValue < rhs.rawValue
    }

    case iPodTouch
    case iPhoneSE
    case iPhone12Mini
    case iPhone8Plus
    case iPhone11Pro
    case iPhone11
    case iPhone12
    case iPhone11ProMax
    case iPhone13ProMax

    case iPadMini_5h
    case iPadMini_6th
    case iPadPro_9_7
    case iPad_9th
    case iPadAir_3rd
    case iPadAir_4th
    case iPadPro_11
    case iPadPro_12_9

    static var iPhones: [Self] {
        Device.allCases.filter { $0.type == .iPhone }
    }

    static var iPads: [Self] {
        Device.allCases.filter { $0.type == .iPad }
    }

    var info: DeviceInfo {
        switch self {
        case .iPodTouch: return .iPodTouch
        case .iPhoneSE: return .iPhoneSE
        case .iPhone12Mini: return .iPhone12Mini
        case .iPhone8Plus: return .iPhone8Plus
        case .iPhone11Pro: return .iPhone11Pro
        case .iPhone11: return .iPhone11
        case .iPhone12: return .iPhone12
        case .iPhone11ProMax: return .iPhone11ProMax
        case .iPhone13ProMax: return .iPhone13ProMax

        case .iPadMini_5h: return .iPadMini_5h
        case .iPadMini_6th: return .iPadMini_6th
        case .iPadPro_9_7: return .iPadPro_9_7
        case .iPad_9th: return .iPad_9th
        case .iPadAir_3rd: return .iPadAir_3rd
        case .iPadAir_4th: return .iPadAir_4th
        case .iPadPro_11: return .iPadPro_11
        case .iPadPro_12_9: return .iPadPro_12_9
        }
    }

    var name: String {
        info.name
    }

    var inch: String {
        info.inch
    }

    var type: DeviceType {
        info.type
    }

    func size(orientation: DeviceOrientation) -> CGSize {
        switch orientation {
        case .portrait:
            return info.size
        case .landscape:
            return CGSize(width: info.size.height, height: info.size.width)
        }
    }

    func safeArea(orientation: DeviceOrientation) -> SafeAreaProxy {
        .init(screenSize: info.size, safeArea: info.safeArea, orientation: orientation)
    }

    func sizeClass(orientation: DeviceOrientation) -> SizeClasses {
        switch orientation {
        case .portrait:
            return info.portraitSizeClass
        case .landscape:
            return info.landscapeSizeClass
        }
    }
}
