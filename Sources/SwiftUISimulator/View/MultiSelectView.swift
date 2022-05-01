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

    private let selectedItems: Binding<Set<Item>>
    private let allItems: [Item]
    private let row: (Item) -> Row
    private let searchableText: (Item) -> String

    @State private var searchText: String = ""
    @State private var showCancelButton = false

    init(
        selectedItems: Binding<Set<Item>>,
        allItems: [Item],
        searchableText: @escaping (Item) -> String,
        @ViewBuilder row: @escaping (Item) -> Row
    ) {
        self.selectedItems = selectedItems
        self.allItems = allItems
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
        VStack {
            //
            // 􀊫 Search
            //
            HStack {
                //
                // Text field
                //
                SearchTextField("Search", text: $searchText)

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
        .environment(\.editMode, .constant(.active))
    }
}
