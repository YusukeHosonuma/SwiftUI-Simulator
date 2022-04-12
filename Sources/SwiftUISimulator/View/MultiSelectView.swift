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

    init(
        title: String,
        selectedItems: Binding<Set<Item>>,
        allItems: [Item],
        allowNoSelected: Bool,
        @ViewBuilder row: @escaping (Item) -> Row
    ) {
        self.title = title
        self.selectedItems = selectedItems
        self.allItems = allItems
        self.allowNoSelected = allowNoSelected
        self.row = row
    }

    var body: some View {
        NavigationView {
            List(selection: selectedItems) {
                Section {
                    ForEach(allItems, id: \.self) { item in
                        row(item).tag(item)
                    }
                } header: {
                    HStack {
                        Spacer()
                        Button("Select All") {
                            selectedItems.wrappedValue = Set(allItems)
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
