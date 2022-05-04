//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/05/01.
//

import SwiftPrettyPrint
import SwiftUI

struct UserDefaultsWrapper: Identifiable {
    let name: String
    let defaults: UserDefaults

    var id: String { name }
}

struct UserDefaultsView: View {
    private let userDefaults: [(String, UserDefaults)]
    private let type: UserDefaultsType

    init(userDefaults: [(String, UserDefaults)], type: UserDefaultsType) {
        self.userDefaults = userDefaults
        self.type = type
    }

    @State private var searchText = ""
    @State private var isPresentedEditSheet = false
    @State private var isPresentedDeleteConfirmAlert = false
    @State private var editDefaults: UserDefaults? = nil
    @State private var editKey: String? = nil

    var body: some View {
        VStack {
            SearchTextField("Search by key...", text: $searchText)
                .padding()

            Form {
                ForEach(userDefaults, id: \.0) { name, defaults in
                    UserDefaultsSection(
                        name: name,
                        defaults: defaults,
                        type: type,
                        searchText: $searchText
                    )
                }
            }
        }
    }
}
