//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/04/11.
//

import SwiftUI

typealias SafeArea = (top: CGFloat, bottom: CGFloat)

enum DeviceType {
    case iPhone
    case iPad
}

struct DeviceInfo {
    let name: String
    let inch: String
    let size: CGSize
    let portraitSizeClass: SizeClasses
    let landscapeSizeClass: SizeClasses
    let safeArea: SafeArea
    let type: DeviceType

    private init(
        name: String,
        inch: String,
        size: CGSize,
        portraitSizeClass: SizeClasses,
        landscapeSizeClass: SizeClasses,
        safeArea: SafeArea = (20, 0), // TODO: safe area in landscape.
        type: DeviceType
    ) {
        self.name = name
        self.inch = inch
        self.size = size
        self.portraitSizeClass = portraitSizeClass
        self.landscapeSizeClass = landscapeSizeClass
        self.safeArea = safeArea
        self.type = type
    }

    // 💡 References:
    // https://developer.apple.com/design/human-interface-guidelines/ios/visual-design/adaptivity-and-layout/
    // https://qiita.com/MJeeeey/items/a640922da33dacc0fc30
    // https://www.screensizes.app/

    // MARK: iPhone

    //
    // iPod Touch - 4.0 inch
    //
    static let iPodTouch: Self = .init(
        name: "iPod Touch",
        inch: "4.0",
        size: CGSize(width: 320, height: 480),
        portraitSizeClass: (.compact, .regular),
        landscapeSizeClass: (.compact, .compact),
        type: .iPhone
    )

    //
    // iPhone SE (3rd) - 4.7 inch
    //
    static let iPhoneSE: Self = .init(
        name: "iPhone SE (3rd)",
        inch: "4.7",
        size: CGSize(width: 375, height: 667),
        portraitSizeClass: (.compact, .regular),
        landscapeSizeClass: (.compact, .compact),
        type: .iPhone
    )

    //
    // iPhone 12 mini (5.4 inch)
    //
    static let iPhone12Mini: Self = .init(
        name: "iPhone 12 mini",
        inch: "5.4",
        size: CGSize(width: 375, height: 812),
        portraitSizeClass: (.compact, .regular),
        landscapeSizeClass: (.compact, .compact),
        type: .iPhone
    )

    //
    // iPhone 8 Plus (5.5 inch)
    //
    static let iPhone8Plus: Self = .init(
        name: "iPhone 8 Plus",
        inch: "5.5",
        size: CGSize(width: 414, height: 736),
        portraitSizeClass: (.compact, .regular),
        landscapeSizeClass: (.regular, .compact),
        type: .iPhone
    )

    //
    // iPhone 11 Pro (5.8 inch)
    //
    static let iPhone11Pro: Self = .init(
        name: "iPhone 11 Pro",
        inch: "5.8",
        size: CGSize(width: 375, height: 812),
        portraitSizeClass: (.compact, .regular),
        landscapeSizeClass: (.compact, .compact),
        safeArea: (44, 34),
        type: .iPhone
    )

    //
    // iPhone 11 (6.1 inch)
    //
    static let iPhone11: Self = .init(
        name: "iPhone 11",
        inch: "6.1",
        size: CGSize(width: 414, height: 896),
        portraitSizeClass: (.compact, .regular),
        landscapeSizeClass: (.regular, .compact),
        safeArea: (48, 34),
        type: .iPhone
    )

    //
    // iPhone 12 (6.1 inch)
    //
    static let iPhone12: Self = .init(
        name: "iPhone 12",
        inch: "6.1",
        size: CGSize(width: 390, height: 844),
        portraitSizeClass: (.compact, .regular),
        landscapeSizeClass: (.compact, .compact),
        safeArea: (50, 34), // TODO: really?
        type: .iPhone
    )

    //
    // iPhone 11 Pro Max (6.5 inch)
    //
    static let iPhone11ProMax: Self = .init(
        name: "iPhone 11 Pro Max",
        inch: "6.5",
        size: CGSize(width: 414, height: 896),
        portraitSizeClass: (.compact, .regular),
        landscapeSizeClass: (.regular, .compact),
        safeArea: (44, 34),
        type: .iPhone
    )

    //
    // iPhone 13 Pro Max (6.7 inch)
    //
    static let iPhone13ProMax: Self = .init(
        name: "iPhone 13 Pro Max",
        inch: "6.7",
        size: CGSize(width: 428, height: 926),
        portraitSizeClass: (.compact, .regular),
        landscapeSizeClass: (.regular, .compact), // same as `iPhone 12 Pro Max`?
        safeArea: (47, 34),
        type: .iPhone
    )

    // MARK: iPad

    //
    // iPad mini 5th (7.9 inch)
    //
    static let iPadMini_5h: Self = .init(
        name: "iPad mini 5th",
        inch: "7.9",
        size: CGSize(width: 768, height: 1024),
        portraitSizeClass: (.regular, .regular),
        landscapeSizeClass: (.regular, .regular),
        safeArea: (24, 20), // TODO: same as iPad mini (6th) ?
        type: .iPad
    )

    //
    // iPad mini 6th (8.3 inch)
    //
    static let iPadMini_6th: Self = .init(
        name: "iPad mini 6th",
        inch: "8.3",
        size: CGSize(width: 744, height: 1133),
        portraitSizeClass: (.regular, .regular),
        landscapeSizeClass: (.regular, .regular),
        safeArea: (24, 20),
        type: .iPad
    )

    //
    // iPad Pro (9.7 inch)
    //
    static let iPadPro_9_7: Self = .init(
        name: "iPad Pro 9.7",
        inch: "9.7",
        size: CGSize(width: 768, height: 1024),
        portraitSizeClass: (.regular, .regular),
        landscapeSizeClass: (.regular, .regular),
        type: .iPad
    )

    //
    // iPad 9th (10.2 inch)
    //
    static let iPad_9th: Self = .init(
        name: "iPad 9th",
        inch: "10.2",
        size: CGSize(width: 810, height: 1080),
        portraitSizeClass: (.regular, .regular),
        landscapeSizeClass: (.regular, .regular),
        safeArea: (20, 0), // TODO: really?
        type: .iPad
    )

    //
    // iPad Air 3rd (10.5 inch)
    //
    static let iPadAir_3rd: Self = .init(
        name: "iPad Air 3rd",
        inch: "10.5",
        size: CGSize(width: 834, height: 1112),
        portraitSizeClass: (.regular, .regular),
        landscapeSizeClass: (.regular, .regular),
        type: .iPad
    )

    //
    // iPad Air 4th (10.9 inch)
    //
    static let iPadAir_4th: Self = .init(
        name: "iPad Air 4th",
        inch: "10.9",
        size: CGSize(width: 820, height: 1180),
        portraitSizeClass: (.regular, .regular),
        landscapeSizeClass: (.regular, .regular),
        safeArea: (24, 20),
        type: .iPad
    )

    //
    // iPad Pro 11 (11 inch)
    //
    static let iPadPro_11: Self = .init(
        name: "iPad Pro 11",
        inch: "11",
        size: CGSize(width: 834, height: 1194),
        portraitSizeClass: (.regular, .regular),
        landscapeSizeClass: (.regular, .regular),
        safeArea: (24, 20),
        type: .iPad
    )

    //
    // iPad Pro (12.9 inch)
    //
    static let iPadPro_12_9: Self = .init(
        name: "iPad Pro",
        inch: "12.9",
        size: CGSize(width: 1024, height: 1366),
        portraitSizeClass: (.regular, .regular),
        landscapeSizeClass: (.regular, .regular),
        safeArea: (24, 20),
        type: .iPad
    )
}
