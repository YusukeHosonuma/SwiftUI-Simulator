//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/04/30.
//

import SwiftUI

struct Row: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Title")
                .font(.title2)
            Text("Subtitle")
                .foregroundColor(.gray)
        }
        .padding()
    }
}
