//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/04/27.
//

import SwiftUI

public extension View {
    func simulatorDebugFilename(_ file: StaticString = #file) -> some View {
        let filename = String(String(file).split(separator: "/").last ?? "")
        return modifier(DebugFilenameModifier(filename: filename))
    }
}

struct DebugFilenameModifier: ViewModifier {
    private let filename: String

    init(filename: String) {
        self.filename = filename
    }

    @Environment(\.debugFilename) private var debugFilename

    func body(content: Content) -> some View {
        if debugFilename {
            //
            // Display filename on content.
            //
            ZStack(alignment: .topLeading) {
                content
                    .border(.red)
                Text("\(filename)")
                    .font(.caption2)
                    .padding(4)
                    .foregroundColor(.black)
                    .background(Color.yellow)
                    .border(.red)
            }
        } else {
            content
        }
    }
}

struct DebugFilenameEnvironmentKey: EnvironmentKey {
    static var defaultValue: Bool = false
}

public extension EnvironmentValues {
    var debugFilename: Bool {
        get {
            self[DebugFilenameEnvironmentKey.self]
        }
        set {
            self[DebugFilenameEnvironmentKey.self] = newValue
        }
    }
}
