//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/05/01.
//

import Foundation

private let repository = "YusukeHosonuma/SwiftUI-Simulator"
private let ossVersion = "1.6.0" // 💡 Please update version number when data incompatibility occur.

extension UserDefaults {
    static let simulatorKeyPrefix: String = "\(repository)/\(ossVersion)/"
    
    static func isOSSKey(_ key: String) -> Bool {
        key.hasPrefix(repository)
    }
}
