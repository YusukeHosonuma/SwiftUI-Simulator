//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/04/10.
//

import SwiftUI

enum Device: Int, CaseIterable, Comparable {
    static func < (lhs: Device, rhs: Device) -> Bool {
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
    
    var size: CGSize {
        info.size
    }
    
    var safeAreaTop: CGFloat {
        info.safeArea.top
    }
    
    var safeAreaBottom: CGFloat {
        info.safeArea.bottom == 0
            ? info.safeArea.bottom
            : info.safeArea.bottom - 8 // why?
    }
    
    var portraitSizeClass: SizeClasses {
        info.portraitSizeClass
    }
    
    var landscapeSizeClass: SizeClasses {
        info.landscapeSizeClass
    }
    
    var type: DeviceType {
        info.type
    }
}
