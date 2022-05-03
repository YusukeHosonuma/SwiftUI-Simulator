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
    
    private func filteredKeys(_ keys: [String]) -> [String] {
        if searchText.isEmpty {
            return keys
        } else {
            return keys.filter { $0.localizedStandardContains(searchText) }
        }
    }

    @State var toDeleteDefaults: UserDefaultsWrapper?
    
    var body: some View {
        VStack {
            SearchTextField("Search by key...", text: $searchText)
                .padding()

            Form {
                ForEach(userDefaults, id: \.0) { name, defaults in
                    
                    let keys = filteredKeys(defaults.extractKeys(of: type))
                    Section {
                        if keys.isEmpty {
                            Text("No results.")
                                .foregroundColor(.gray)
                        } else {
                            VStack(alignment: .leading) {
                                //
                                // Value
                                //
                                ForEach(keys.sorted(), id: \.self) { key in
                                    UserDefaultsValueRow(name: name, defaults: defaults, key: key)
                                }
                            }
                        }
                    } header: {
                        HStack {
                            //
                            // 􀉩 standard / 􀨤 group.xxx
                            //
                            Label(name, systemImage: name == "standard" ? "person" : "externaldrive.connected.to.line.below")
                            
                            Spacer()
                            
                            if type == .user {
                                //
                                // 􀍡
                                //
                                Menu {
                                    Button {
                                        toDeleteDefaults = .init(name: name, defaults: defaults)
                                    } label: {
                                        Label("Delete All Keys", systemImage: "trash")
                                    }
                                    .disabled(keys.isEmpty)
                                } label: {
                                    Image(systemName: "ellipsis.circle")
                                }
                            }
                        }
                        .font(.subheadline)
                    }
                    .textCase(nil)
                    .alert(item: $toDeleteDefaults) { defaultsWrapper in
                        //
                        // ⚠️ Delete all keys
                        //
                        Alert(
                            title: Text("Delete All Keys?"),
                            message: Text("Are you delete all keys from '\(defaultsWrapper.name)'?"),
                            primaryButton: .cancel(),
                            secondaryButton: .destructive(Text("Delete"), action: {
                                defaultsWrapper.defaults.removeAll()
                            })
                        )
                    }
                }
            }
        }

    }
}
