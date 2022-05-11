//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/04/10.
//

import SwiftUI
import SwiftUICommon

//
// ☑️ `DynamicTypeSize` is supported in iOS 15+.
//
enum DynamicTypeSizeWrapper: Int {
    case xSmall = 0
    case small
    case medium
    case large
    case xLarge
    case xxLarge
    case xxxLarge

    var label: String {
        switch self {
        case .xSmall: return "xSmall"
        case .small: return "small"
        case .medium: return "medium"
        case .large: return "large"
        case .xLarge: return "xLarge"
        case .xxLarge: return "xxLarge"
        case .xxxLarge: return "xxxLarge"
        }
    }

    //
    // 🔗 Bridge to native `DynamicTypeSize`
    //
    @available(iOS 15, *)
    var nativeValue: DynamicTypeSize {
        switch self {
        case .xSmall: return .xSmall
        case .small: return .small
        case .medium: return .medium
        case .large: return .large
        case .xLarge: return .xLarge
        case .xxLarge: return .xxLarge
        case .xxxLarge: return .xxxLarge
        }
    }
}

extension DynamicTypeSizeWrapper: SliderValue {
    static let sliderRange: ClosedRange<Double> = 0 ... 6

    var sliderIndex: Int { rawValue }

    init(fromSliderIndex index: Int) {
        self = Self(rawValue: index)!
    }
}
