//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/04/30.
//

import SwiftUI

struct CatalogListView: View {
    let items: [CatalogItem]
    let devices: [Device]

    @Environment(\.presentationMode) private var presentationMode

    @State private var isDark = false
    @State private var value: Double = 1.0
    @State private var dynamicTypeSize: DynamicTypeSizeWrapper = .medium
    @State private var selection: UUID? = nil

    private let rows: [GridItem] = [
        .init(.adaptive(minimum: 320)),
    ]

    var body: some View {
        NavigationView {
            VStack {
                ScrollView(.vertical) {
                    LazyVGrid(columns: rows, spacing: 32) {
                        ForEach(items) { item in
                            ZStack {
                                NavigationLink(tag: item.id, selection: $selection) {
                                    CatalogDetailView(item: item, devices: devices)
                                } label: {
                                    EmptyView()
                                }

                                CatalogThumnailView(item: item, ratio: $value, dynamicTypeSize: $dynamicTypeSize) { item in
                                    selection = item.id
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Catalog")
            .toolbar {
                ToolbarItem(placement: .destructiveAction) {
                    Button("Close") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }

                ToolbarItemGroup(placement: .bottomBar) {
                    //
                    // Width
                    //
                    HStack {
                        Slider(value: $value)
                            .frame(width: 200)
                        Spacer()
                        Text("width: \(Int(value * 320))")
                    }
                    .frame(width: 300)

                    Spacer()

                    //
                    // Dynamic Type Sizes
                    //
                    HStack {
                        DynamicTypeSizeSlider(dynamicTypeSize: $dynamicTypeSize)
                            .frame(width: 200)
                        Spacer()
                        Text(dynamicTypeSize.label)
                    }
                    .frame(width: 300)

                    Spacer()

                    //
                    // 􀀂 Light / Dark
                    //
                    Button {
                        isDark.toggle()
                    } label: {
                        Icon(isDark ? "sun.max" : "moon")
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
        .environment(\.colorScheme, isDark ? .dark : .light)
    }
}
