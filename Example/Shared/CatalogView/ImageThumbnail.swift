//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/04/30.
//

import SwiftUI

struct ImageThumbnail: View {
    @Environment(\.colorScheme) var colorScheme

    var imageName: String
    var title: String

    var body: some View {
        ZStack(alignment: .bottom) {
            ZStack {
                if colorScheme == .dark {
                    Color.black
                } else {
                    Color.white
                }
                Image(imageName)
                    .resizable()
                    .scaledToFit()
            }
            HStack {
                Text(title)
                    .padding(4)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .background(Color.gray.opacity(0.3))
        }
    }
}
