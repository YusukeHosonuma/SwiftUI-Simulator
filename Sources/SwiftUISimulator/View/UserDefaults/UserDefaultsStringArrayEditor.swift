//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/05/03.
//

import SwiftUI

struct UserDefaultsStringArrayEditor: View {
    @Binding var strings: [String]
    @State var editMode: EditMode = .inactive

    var body: some View {
        ScrollViewReader { scrollProxy in
            List {
                ForEach(Array(strings.indices), id: \.self) { index in
                    if editMode.isEditing {
                        Text(strings[index])
                    } else {
                        //
                        // ⚠️ Do not use `Binding` directly. (it cause crash when `onDelete`)
                        // https://zenn.dev/usk2000/articles/563a79015bf59a
                        //
                        TextEditor(text: .init(get: {
                            strings[index]
                        }, set: {
                            strings[index] = $0
                        }))
                        .border(.gray.opacity(0.5))
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    }
                }
                .onMove { source, destination in
                    strings.move(fromOffsets: source, toOffset: destination)
                }
                .when(editMode.isEditing) {
                    $0.onDelete { indexSet in
                        strings.remove(atOffsets: indexSet)
                    }
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Spacer()
                    //
                    // Edit / Done
                    //
                    if editMode.isEditing {
                        Button("Done") {
                            editMode = .inactive
                        }
                    } else {
                        Button("Edit") {
                            editMode = .active
                        }
                    }
                    //
                    // 􀅼
                    //
                    Button {
                        strings.append("")
                        withAnimation {
                            scrollProxy.scrollTo(strings.count - 2, anchor: .top)
                        }
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .environment(\.editMode, $editMode)
        }
    }
}
