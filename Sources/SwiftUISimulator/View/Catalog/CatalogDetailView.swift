//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/04/30.
//

import SwiftUI

struct CatalogDetailView: View {
    let item: CatalogItem
    let devices: [Device]

    var body: some View {
        ScrollView {
            HStack {
                Spacer()
                VStack(spacing: 24) {
                    ForEach(devices) { device in
                        VStack {
                            Text(device.name).font(.title2)
                            row(width: device.info.size.width)
                        }
                    }
                }
                Spacer()
            }
        }
        .navigationTitle(item.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    func row(width: CGFloat) -> some View {
        HStack(alignment: .center) {
            Group {
                ZStack {
                    Color.black
                    item.content()
                        .environment(\.colorScheme, .dark)
                        .background(Color.black)
                }
                ZStack {
                    Color.white
                    item.content()
                        .environment(\.colorScheme, .light)
                        .background(Color.white)
                }
            }
            .border(.blue)
            .frame(width: width, height: 400)
            .border(.gray)
        }
    }
}
