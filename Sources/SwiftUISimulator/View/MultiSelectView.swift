//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/04/12.
//

import SwiftUI

struct MultiItemSelectView<Item, Row>: View where Item: Hashable, Row: View {
    // 💡 iOS 15+: `\.dismiss`
    @Environment(\.presentationMode) private var presentationMode

    private let title: String
    private let selectedItems: Binding<Set<Item>>
    private let allItems: [Item]
    private let allowNoSelected: Bool
    private let row: (Item) -> Row
    private let searchableText: (Item) -> String
    
    @State private var searchText: String = ""
    @State private var showCancelButton = false

    init(
        title: String,
        selectedItems: Binding<Set<Item>>,
        allItems: [Item],
        allowNoSelected: Bool,
        searchableText: @escaping (Item) -> String,
        @ViewBuilder row: @escaping (Item) -> Row
    ) {
        self.title = title
        self.selectedItems = selectedItems
        self.allItems = allItems
        self.allowNoSelected = allowNoSelected
        self.searchableText = searchableText
        self.row = row
    }

    private var items: [Item] {
        if searchText.isEmpty {
            return allItems
        } else {
            return allItems.filter { item in
                searchText
                    .split(separator: " ")
                    .reduce(true) { result, text in
                        result && searchableText(item).localizedCaseInsensitiveContains(text)
                    }
            }
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                //
                // 􀊫 Search
                //
                HStack {
                    //
                    // Text field
                    //
                    HStack {
                        Image(systemName: "magnifyingglass")

                        TextField("Search", text: $searchText, onEditingChanged: { _ in
                            self.showCancelButton = true
                        })
                        .autocapitalization(.none)
                        .disableAutocorrection(true)

                        Button {
                            searchText = ""
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .opacity(searchText == "" ? 0 : 1)
                        }
                    }
                    .padding(8)
                    .foregroundColor(.secondary)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10.0)

                    //
                    // Cancel button
                    //
                    if showCancelButton {
                        Button("Cancel") {
                            hideKeyboard()
                            searchText = ""
                            showCancelButton = false
                        }
                    }
                }
                .padding(.horizontal)

                //
                // 􀋲 Items
                //
                List(selection: selectedItems) {
                    Section {
                        ForEach(items, id: \.self) { item in
                            row(item).tag(item)
                        }
                    } header: {
                        HStack {
                            Spacer()
                            if searchText.isEmpty {
                                Button("Select All") {
                                    selectedItems.wrappedValue = Set(allItems)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle(title)
            .environment(\.editMode, .constant(.active))
            .toolbar {
                ToolbarItem(placement: .destructiveAction) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    // ☑️ Note: It is useless if it does not prevent the sheet from closing.
                    .disabled(allowNoSelected == false && selectedItems.wrappedValue.isEmpty)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Clear") {
                        selectedItems.wrappedValue = []
                    }
                }
            }
        }
    }
}
