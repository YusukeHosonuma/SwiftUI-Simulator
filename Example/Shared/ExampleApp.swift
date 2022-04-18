//
//  ExampleApp.swift
//  Shared
//
//  Created by Yusuke Hosonuma on 2022/04/18.
//

import SwiftUI
import SwiftUISimulator

@main
struct ExampleApp: App {
    var body: some Scene {
        WindowGroup {
            SimulatorView {
                ContentView()
            }
        }
    }
}
