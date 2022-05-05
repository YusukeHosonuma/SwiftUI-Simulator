//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/04/13.
//

import SwiftUI

extension Font {
    static let codeStyle: Self = .system(size: 14, weight: .regular, design: .monospaced)
}

extension Font.TextStyle {
    var name: String {
        switch self {
        case .largeTitle: return "largeTitle"
        case .title: return "title"
        case .title2: return "title2"
        case .title3: return "title3"
        case .headline: return "headline"
        case .subheadline: return "subheadline"
        case .body: return "body"
        case .callout: return "callout"
        case .footnote: return "footnote"
        case .caption: return "caption"
        case .caption2: return "caption2"
        @unknown default: return "unknown"
        }
    }
}
