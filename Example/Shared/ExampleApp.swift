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
    @State private var isEnableDebugFilename = false
    #endif

    var body: some Scene {
        WindowGroup {
            #if DEBUG
            SimulatorView(
                catalogItems: catalogItems,
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

//
// Catalog data.
//
#if DEBUG
fileprivate extension ExampleApp {
    var catalogItems: [CatalogItem] {
        [
            .init(title: "Text", description: "sample") {
                AnyView(
                    Text("Hello, SwiftUI-Simulator.")
                )
            },
            .init(title: "Button", description: "sample") {
                AnyView(
                    Button("Button") {}
                )
            },
            .init(title: "Toggle", description: "sample") {
                AnyView(
                    Toggle("Toggle", isOn: .constant(true))
                )
            },
            .init(title: "StarButton", description: "original") {
                AnyView(
                    StarButton()
                )
            },
            .init(title: "Row", description: "original") {
                AnyView(
                    List {
                        Row()
                    }
                )
            },
            .init(
                title: "ImageThumbnail",
                description: "original",
                template: "ImageThumbnail(imageName: <#String#>, title: <#String#>)"
            ) {
                AnyView(
                    ImageThumbnail(imageName: "sea", title: "Sea")
                )
            },
        ]
    }
}
#endif

extension View {
    func debugFilename(_ file: StaticString = #file) -> some View {
        #if DEBUG
        simulatorDebugFilename(file)
        #else
        self
        #endif
    }
}
