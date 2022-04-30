//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/04/30.
//

import SwiftUI

struct CatalogThumnailView: View {
    var item: CatalogItem
    @Binding var ratio: Double
    @Binding var dynamicTypeSize: DynamicTypeSizeWrapper
    var onTapped: (CatalogItem) -> Void

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(item.title)
                    .font(.headline)
                Spacer()
                if let template = item.template {
                    Menu {
                        Button {
                            print(template)
                        } label: {
                            Label("Console", systemImage: "terminal")
                        }
                        Button {
                            UIPasteboard.general.string = template
                        } label: {
                            Label("Copy", systemImage: "doc.on.doc")
                        }
                    } label: {
                        Image(systemName: "chevron.left.forwardslash.chevron.right")
                    }
                }
            }
            HStack {
                Spacer(minLength: 0)
                item.content()
                    .frame(width: 320 * ratio, height: 240 * ratio)
                    .border(.gray.opacity(0.5))
                    .extend {
                        if #available(iOS 15, *) {
                            $0.environment(\.dynamicTypeSize, dynamicTypeSize.nativeValue)
                        } else {
                            $0
                        }
                    }
                Spacer(minLength: 0)
            }
            .frame(width: 320, height: 240)
            .clipped()
            .border(.gray)
            .contentShape(Rectangle())
            .onTapGesture {
                onTapped(item)
            }

            Text(item.description)
                .font(.footnote)
                .foregroundColor(.gray)
        }
        .frame(width: 320)
    }
}
