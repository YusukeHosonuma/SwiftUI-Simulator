//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/05/02.
//

import SwiftUI

extension AnyTransition {
    static func verticalSlide(_ offset: CGFloat) -> AnyTransition {
        .modifier(
            active: VerticalSlideModifier(offset: offset),
            identity: VerticalSlideModifier(offset: 0)
        )
    }
}

private struct VerticalSlideModifier: ViewModifier {
    let offset: CGFloat

    func body(content: Content) -> some View {
        content
            .offset(x: 0, y: offset)
    }
}
