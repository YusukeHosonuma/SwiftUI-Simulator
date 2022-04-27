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
    #if DEBUG
    @State private var isPresentAlert = false
    #endif
    
    var body: some Scene {
        WindowGroup {
            #if DEBUG
            SimulatorView(debugMenu: {
                //
                // Debug 􀌜
                //
                Menu {
                    Button("Show Alert") { isPresentAlert.toggle() }
                } label: {
                    Label("Debug", systemImage: "ant.circle")
                }
            }) {
                ContentView()
                    .alert(isPresented: $isPresentAlert) {
                        Alert(
                            title: Text("Custom Debug Action"),
                            message: Text("This is example alert.")
                        )
                    }
            }
            #else
            ContentView()
            #endif
        }
    }
}
