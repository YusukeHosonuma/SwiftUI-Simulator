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
    case iPhone8Plus
    case iPhone11ProMax
    case iPadMini_6th

    var name: String {
        switch self {
        case .iPodTouch:
            return "iPod Touch"
        case .iPhoneSE:
            return "iPhone SE - 4.7 inch"
        case .iPhone8Plus:
            return "iPhone 8 Plus - 5.5 inch"
        case .iPhone11ProMax:
            return "iPhone 11 Pro Max - 6.5 inch"
        case .iPadMini_6th:
            return "iPad mini (6th)"
        }
    }

    var size: CGSize {
        switch self {
        case .iPodTouch:
            return CGSize(width: 320, height: 480)
        case .iPhoneSE:
            return CGSize(width: 375, height: 667)
        case .iPhone8Plus:
            return CGSize(width: 414, height: 736)
        case .iPhone11ProMax:
            return CGSize(width: 414, height: 896)
        case .iPadMini_6th:
            return CGSize(width: 744, height: 1133)
        }
    }

    var safeAreaTop: CGFloat {
        switch self {
        case .iPhone11ProMax:
            return 44
        default:
            return 20
        }
    }

    var safeAreaBottom: CGFloat {
        switch self {
        case .iPhone11ProMax:
            return 34 - 8
        default:
            return 0
        }
    }

    var portraitSizeClass: SizeClasses {
        switch self {
        case .iPadMini_6th:
            return (.regular, .regular)
        default:
            return (.compact, .regular)
        }
    }

    var landscapeSizeClass: SizeClasses {
        switch self {
        case .iPodTouch, .iPhoneSE:
            return (.compact, .compact)
        case .iPhone8Plus, .iPhone11ProMax:
            return (.regular, .compact)
        default:
            return (.regular, .regular) // any iPad
        }
    }

    var isIpad: Bool {
        size.width >= 744
    }
}
