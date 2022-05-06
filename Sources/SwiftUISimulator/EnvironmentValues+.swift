//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/05/02.
//

import SwiftUI

public typealias SimulatedSheetDismissAction = () -> Void

public extension EnvironmentValues {
    var simulatedSheetDismiss: SimulatedSheetDismissAction? {
        get {
            self[SimulatedSheetDismissEnvironmentKey.self]
        }
        set {
            self[SimulatedSheetDismissEnvironmentKey.self] = newValue
        }
    }
}

struct SimulatedSheetDismissEnvironmentKey: EnvironmentKey {
    static var defaultValue: SimulatedSheetDismissAction?
}
