//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/04/30.
//

import SwiftUI

public struct UserDefaultsSheet: View {
    // 💡 iOS 15+: `\.dismiss`
    @Environment(\.presentationMode) private var presentationMode

    private let suiteNames: [String]
    private let accentColor: Color
    private let excludeKeys: (String) -> Bool
    
    public init(
        suiteNames: [String] = [],
        excludeKeys: @escaping (String) -> Bool = { _ in false },
        accentColor: Color = .accentColor
    ) {
        self.suiteNames = suiteNames
        self.excludeKeys = excludeKeys
        self.accentColor = accentColor
    }
    
    private var userDefaults: [(String, UserDefaults)] {
        [("standard", UserDefaults.standard)] +
            suiteNames.compactMap { name in
                UserDefaults(suiteName: name).map { (name, $0) }
            }
    }

    private var defaults: [UserDefaultsContainer] {
        let standard = UserDefaultsContainer(
            name: "standard",
            defaults: .standard,
            excludeKeys: excludeKeys
        )
        
        return [standard] + suiteNames.compactMap { name in
            UserDefaults(suiteName: name).map {
                UserDefaultsContainer(
                    name: name,
                    defaults: $0,
                    excludeKeys: excludeKeys
                )
            }
        }
    }

    public var body: some View {
        TabView {
            content(title: "User") {
                UserDefaultsView(type: .user, defaultsContainers: defaults)
            }
            .tabItem {
                Label("User", systemImage: "person")
            }

            content(title: "System") {
                UserDefaultsView(type: .system, defaultsContainers: defaults)
            }
            .tabItem {
                Label("System", systemImage: "iphone")
            }
        }
        .accentColor(accentColor)
        .environment(\.customAccentColor, accentColor)
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
