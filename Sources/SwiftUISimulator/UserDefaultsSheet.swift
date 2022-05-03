//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/04/30.
//

import SwiftUI

struct UserDefaultsSheet: View {
    // 💡 iOS 15+: `\.dismiss`
    @Environment(\.presentationMode) private var presentationMode

    var suiteNames: [String]

    private var userDefaults: [(String, UserDefaults)] {
        [("standard", UserDefaults.standard)] +
            suiteNames.compactMap { name in
                UserDefaults(suiteName: name).map { (name, $0) }
            }
    }

    var body: some View {
        TabView {
            content(title: "User") {
                UserDefaultsView(
                    userDefaults: userDefaults,
                    extractKeys: { $0.userKeys }
                )
            }
            .tabItem {
                Label("User", systemImage: "person")
            }

            content(title: "System") {
                UserDefaultsView(
                    userDefaults: userDefaults,
                    extractKeys: { $0.systemKeys }
                )
            }
            .tabItem {
                Label("System", systemImage: "iphone")
            }
        }
    }

    private func content(title: String, content: () -> UserDefaultsView) -> some View {
        NavigationView {
            content()
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Done") {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
        }
        .navigationViewStyle(.stack)
    }
}
