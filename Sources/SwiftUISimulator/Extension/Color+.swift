//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/04/13.
//

import SwiftUI

extension Color {
    static var info: Self {
        .gray.opacity(0.9)
    }

    static var safeArea: Self {
        .pink.opacity(0.1)
    }

    static var toolbarBorder: Self {
        .init(red: 0.85, green: 0.85, blue: 0.85, opacity: 0.9)
    }

    static var toolbarBackground: Self {
        .init(red: 0.98, green: 0.98, blue: 0.98, opacity: 0.9)
    }
    
    static var simulatorBackground: Self {
        .white
    }
}

extension Color: CaseIterable {
    public static var allCases: [Color] {
        if #available(iOS 15.0, *) {
            return [
                .red,
                .orange,
                .yellow,
                .green,
                .mint,
                .teal,
                .cyan,
                .blue,
                .indigo,
                .purple,
                .pink,
                .brown,
                .white,
                .gray,
                .black,
                .clear,
                .primary,
                .secondary,
            ]
        } else {
            return [
                .red,
                .orange,
                .yellow,
                .green,
                .blue,
                .purple,
                .pink,
                .white,
                .gray,
                .black,
                .clear,
                .primary,
                .secondary,
            ]
        }
    }

    var name: String {
        if #available(iOS 15.0, *) {
            switch self {
            case .red: return "Red"
            case .orange: return "Orange"
            case .yellow: return "Yellow"
            case .green: return "Green"
            case .mint: return "Mint"
            case .teal: return "Teal"
            case .cyan: return "Cyan"
            case .blue: return "Blue"
            case .indigo: return "Indigo"
            case .purple: return "Purple"
            case .pink: return "Pink"
            case .brown: return "Brown"
            case .white: return "White"
            case .gray: return "Gray"
            case .black: return "Black"
            case .clear: return "Clear"
            case .primary: return "Primary"
            case .secondary: return "Secondary"
            default:
                preconditionFailure()
            }
        } else {
            switch self {
            case .red: return "Red"
            case .orange: return "Orange"
            case .yellow: return "Yellow"
            case .green: return "Green"
            case .blue: return "Blue"
            case .purple: return "Purple"
            case .pink: return "Pink"
            case .white: return "White"
            case .gray: return "Gray"
            case .black: return "Black"
            case .clear: return "Clear"
            case .primary: return "Primary"
            case .secondary: return "Secondary"
            default:
                preconditionFailure()
            }
        }
    }
}
