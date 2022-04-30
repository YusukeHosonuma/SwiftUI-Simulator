//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/04/10.
//

import SwiftUI

extension View {
    func extend<V: View>(@ViewBuilder transform: (Self) -> V) -> some View {
        transform(self)
    }

    @ViewBuilder
    func when<Content: View>(_ condition: Bool, @ViewBuilder transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }

    @ViewBuilder
    func whenLet<V, Content: View>(_ optional: V?, @ViewBuilder transform: (Self, V) -> Content) -> some View {
        if let value = optional {
            transform(self, value)
        } else {
            self
        }
    }

    func border(_ color: Color, width: CGFloat, edge: Edge.Set) -> some View {
        VStack(spacing: 0) {
            if edge == .top || edge == .vertical {
                color.frame(height: width)
            }
            HStack(spacing: 0) {
                if edge == .leading || edge == .horizontal {
                    color.frame(width: width)
                }

                self

                if edge == .trailing || edge == .horizontal {
                    color.frame(width: width)
                }
            }
            if edge == .bottom || edge == .vertical {
                color.frame(height: width)
            }
        }
    }

    func hideKeyboard() {
        UIApplication.hideKeyboard()
    }
}
