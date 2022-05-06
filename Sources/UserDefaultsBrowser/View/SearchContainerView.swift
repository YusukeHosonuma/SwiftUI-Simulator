//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/05/01.
//

import SwiftPrettyPrint
import SwiftUI

struct SearchContainerView: View {
    let type: UserDefaultsType
    let defaultsContainers: [UserDefaultsContainer]

    init(type: UserDefaultsType, defaults: [UserDefaultsContainer]) {
        self.type = type
        defaultsContainers = defaults
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
                ForEach(defaultsContainers) { defaults in
                    SectionView(
                        defaults: defaults,
                        type: type,
                        searchText: $searchText
                    )
                }
            }
        }
    }
}
