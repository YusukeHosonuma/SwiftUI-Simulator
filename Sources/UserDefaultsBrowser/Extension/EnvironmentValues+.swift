//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/05/06.
//

import SwiftUI

public struct CustomAccentColor: EnvironmentKey {
    public static var defaultValue: Color = .accentColor
}

public extension EnvironmentValues {
    var customAccentColor: Color {
        get { self[CustomAccentColor.self] }
        set { self[CustomAccentColor.self] = newValue }
    }
}
