//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/04/17.
//

import SwiftUI

extension LegibilityWeight: RawRepresentable {
    public init?(rawValue: String) {
        switch rawValue {
        case "regular": self = .regular
        case "bold": self = .bold
        default:
            preconditionFailure()
        }
    }

    public var rawValue: String {
        switch self {
        case .regular: return "regular"
        case .bold: return "bold"
        @unknown default:
            preconditionFailure()
        }
    }
}
