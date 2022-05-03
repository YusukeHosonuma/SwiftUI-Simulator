//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/05/01.
//

import SwiftPrettyPrint
import SwiftUI

struct UserDefaultsView: View {
    private let userDefaults: [(String, UserDefaults)]
    private let extractKeys: (UserDefaults) -> [String]

    init(userDefaults: [(String, UserDefaults)], extractKeys: @escaping (UserDefaults) -> [String]) {
        self.userDefaults = userDefaults
        self.extractKeys = extractKeys
    }

    @State private var searchText = ""
    @State private var isPresentedEditSheet = false
    @State private var editDefaults: UserDefaults? = nil
    @State private var editKey: String? = nil

    private func filteredKeys(_ keys: [String]) -> [String] {
        if searchText.isEmpty {
            return keys
        } else {
            return keys.filter { $0.localizedStandardContains(searchText) }
        }
    }

    var body: some View {
        VStack {
            SearchTextField("Search by key...", text: $searchText)
                .padding()

            Form {
                ForEach(userDefaults, id: \.0) { name, defaults in
                    let keys = filteredKeys(extractKeys(defaults))
                    Section {
                        if keys.isEmpty {
                            Text("No results.")
                                .foregroundColor(.gray)
                        } else {
                            VStack(alignment: .leading) {
                                ForEach(keys.sorted(), id: \.self) { key in
                                    UserDefaultsValueRow(name: name, defaults: defaults, key: key)
                                }
                            }
                        }
                    } header: {
                        Label(name, systemImage: name == "standard" ? "person" : "externaldrive.connected.to.line.below")
                    }
                    .textCase(nil)
                }
            }
        }
    }
}
