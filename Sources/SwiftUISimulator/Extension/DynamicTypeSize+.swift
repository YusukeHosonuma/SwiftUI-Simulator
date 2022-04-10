//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/04/10.
//

import SwiftUI

extension DynamicTypeSize: SliderValue { // TODO: DynamicTypeSize is iOS 15+
    static let sliderRange: ClosedRange<Double> = 0 ... 6

    var sliderIndex: Int { rawValue }

    init(fromSliderIndex index: Int) {
        self = Self(rawValue: index)!
    }

    var label: String {
        switch self {
        case .xSmall: return "xSmall"
        case .small: return "small"
        case .medium: return "medium"
        case .large: return "large"
        case .xLarge: return "xLarge"
        case .xxLarge: return "xxLarge"
        case .xxxLarge: return "xxxLarge"
        default:
            preconditionFailure()
        }
    }
}

extension DynamicTypeSize: RawRepresentable {
    public var rawValue: Int {
        switch self {
        case .xSmall: return 0
        case .small: return 1
        case .medium: return 2
        case .large: return 3
        case .xLarge: return 4
        case .xxLarge: return 5
        case .xxxLarge: return 6
        default:
            preconditionFailure()
        }
    }

    public init?(rawValue: Int) {
        switch rawValue {
        case 0: self = .xSmall
        case 1: self = .small
        case 2: self = .medium
        case 3: self = .large
        case 4: self = .xLarge
        case 5: self = .xxLarge
        case 6: self = .xxxLarge
        default:
            preconditionFailure()
        }
    }
}
