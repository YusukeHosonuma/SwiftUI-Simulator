//
//  ExampleApp.swift
//  Shared
//
//  Created by Yusuke Hosonuma on 2022/04/18.
//

import SwiftUI
import SwiftUISimulator

let groupID = "group.swiftui-simulator-example"

@main
struct ExampleApp: App {
    #if DEBUG
    @State private var isPresentAlert = false
    @State private var isEnableDebugFilename = false
    #endif

    var body: some Scene {
        WindowGroup {
            #if DEBUG
            SimulatorView(
                userDefaultsSuiteNames: [groupID],
                debugMenu: {
                    //
                    // Debug 􀌜
                    //
                    Menu {
                        //
                        // Filename 􀈷
                        //
                        Toggle(isOn: $isEnableDebugFilename) {
                            Label("Filename", systemImage: "doc")
                        }
                        //
                        // Show Alert 􀫊
                        //
                        Button {
                            isPresentAlert.toggle()
                        } label: {
                            Label("Show Alert", systemImage: "swift")
                        }
                    } label: {
                        Label("Debug", systemImage: "ant.circle")
                    }
                }
            ) {
                ContentView()
                    .environment(\.simulatorDebugFilename, isEnableDebugFilename)
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

extension View {
    func debugFilename(_ file: StaticString = #file) -> some View {
        #if DEBUG
        simulatorDebugFilename(file)
        #else
        self
        #endif
    }
}
