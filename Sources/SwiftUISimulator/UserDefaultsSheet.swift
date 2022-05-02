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

    var body: some View {
        TabView {
            content(title: "User") {
                UserDefaultsView(
                    userDefaults: UserDefaults.standard,
                    keys: UserDefaults.standard.userKeys
                )
            }
            .tabItem {
                Label("User", systemImage: "person")
            }

            content(title: "System") {
                UserDefaultsView(
                    userDefaults: UserDefaults.standard,
                    keys: UserDefaults.standard.systemKeys
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
                .toolbar {
                    ToolbarItem(placement: .destructiveAction) {
                        Button("Done") {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
        }
        .navigationViewStyle(.stack)
    }
}
