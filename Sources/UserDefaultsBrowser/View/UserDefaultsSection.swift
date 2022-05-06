//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/05/04.
//

import SwiftPrettyPrint
import SwiftUI

struct UserDefaultsSection: View {
    let defaults: UserDefaultsContainer
    let type: UserDefaultsType
    @Binding var searchText: String

    @State private var toDeleteDefaults: UserDefaultsContainer?
    @State private var contentID = UUID() // for force-update to view.
    @State private var isExpanded: Bool = false

    private var allKeys: [String] {
        defaults.extractKeys(of: type)
    }

    private var filteredKeys: [String] {
        if searchText.isEmpty {
            return allKeys
        } else {
            return allKeys.filter { $0.localizedStandardContains(searchText) }
        }
    }

    var body: some View {
        DisclosureGroup(isExpanded: $isExpanded) {
            if filteredKeys.isEmpty {
                Text("No results.")
                    .foregroundColor(.gray)
            } else {
                VStack(alignment: .leading) {
                    //
                    // Value
                    //
                    ForEach(filteredKeys.sorted(), id: \.self) { key in
                        UserDefaultsValueRow(
                            defaults: defaults,
                            key: key,
                            onUpdate: { contentID = UUID() }
                        )
                    }
                }
                .id(contentID)
            }
        } label: {
            HStack {
                //
                // 􀉩 standard / 􀨤 group.xxx
                //
                Label(
                    defaults.name,
                    systemImage: defaults.name == "standard" ? "person" : "externaldrive.connected.to.line.below"
                )

                Spacer()

                //
                // 􀍡
                //
                if type == .user {
                    Menu {
                        Group {
                            //
                            // 􀩼 Dump as Swift code
                            //
                            Button {
                                print(exportSwiftCode)
                            } label: {
                                Label("Dump as Swift code", systemImage: "terminal")
                            }

                            //
                            // 􀙚 Dump as JSON
                            //
                            Button {
                                print(exportJSON)
                            } label: {
                                Label("Dump as JSON", systemImage: "terminal")
                            }

                            Divider() // ----
                        }

                        Group {
                            //
                            // 􀩼 Copy as Swift code
                            //
                            Button {
                                UIPasteboard.general.string = exportSwiftCode
                            } label: {
                                Label("Copy as Swift code", systemImage: "doc.on.doc")
                            }

                            //
                            // 􀙚 Copy as JSON
                            //
                            Button {
                                UIPasteboard.general.string = exportJSON
                            } label: {
                                Label("Copy as JSON", systemImage: "doc.on.doc")
                            }

                            Divider() // ----
                        }

                        //
                        // 􀈑 Delete All Keys
                        //
                        Group {
                            if #available(iOS 15.0, *) {
                                Button(role: .destructive) {
                                    toDeleteDefaults = defaults
                                } label: {
                                    Label("Delete All Keys", systemImage: "trash")
                                }
                            } else {
                                Button {
                                    toDeleteDefaults = defaults
                                } label: {
                                    Label("Delete All Keys", systemImage: "trash")
                                }
                            }
                        }
                        .disabled(filteredKeys.isEmpty)
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .padding(.trailing, 8)
                    }
                }
            }
        }
        .textCase(nil)
        .onAppear {
            isExpanded = UserDefaults.standard.bool(forKey: isExpandedKey)
        }
        .onChange(of: isExpanded) {
            UserDefaults.standard.set($0, forKey: isExpandedKey)
        }
        .alert(item: $toDeleteDefaults) { defaultsWrapper in
            //
            // ⚠️ Delete all keys
            //
            Alert(
                title: Text("Delete All Keys?"),
                message: Text("Are you delete all keys from '\(defaultsWrapper.name)'?"),
                primaryButton: .cancel(),
                secondaryButton: .destructive(Text("Delete"), action: {
                    defaults.removeAll(of: type)
                })
            )
        }
    }

    private var isExpandedKey: String {
        //
        // e.g. "xxx/xxx/isExpanded/user.standard"
        //
        UserDefaults.keyPrefix + "isExpanded/\(type.rawValue).\(defaults.name)"
    }

    private var exportSwiftCode: String {
        let dict = allKeys.reduce(into: [String: Any]()) { dict, key in
            dict[key] = defaults.lookup(forKey: key)
        }

        var string = ""
        Pretty.prettyPrintDebug(dict, to: &string)
        return string
    }

    private var exportJSON: String {
        let dict = allKeys
            .reduce(into: [String: Any]()) { dict, key in
                let value = defaults.lookup(forKey: key)

                switch value {
                case let url as URL:
                    dict[key] = url.absoluteString
                case let date as Date:
                    dict[key] = date.toString()
                default:
                    dict[key] = value
                }
            }

        return dict.prettyJSON
    }
}
