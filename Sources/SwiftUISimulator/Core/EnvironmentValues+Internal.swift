//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/05/02.
//

import SwiftUI

extension EnvironmentValues {
    var simulatorEnabled: Bool {
        get {
            self[SimulatorEnabledEnvironmentKey.self]
        }
        set {
            self[SimulatorEnabledEnvironmentKey.self] = newValue
        }
    }

    var simulatedDevice: Device? {
        get {
            self[SimulatedDeviceEnvironmentKey.self]
        }
        set {
            self[SimulatedDeviceEnvironmentKey.self] = newValue
        }
    }
}

struct SimulatedDeviceEnvironmentKey: EnvironmentKey {
    static var defaultValue: Device?
}

struct SimulatorEnabledEnvironmentKey: EnvironmentKey {
    static var defaultValue: Bool = false
}
