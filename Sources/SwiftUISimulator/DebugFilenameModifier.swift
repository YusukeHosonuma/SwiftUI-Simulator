//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/04/27.
//

import SwiftUI

public extension View {
    func simulatorDebugFilename(_ file: StaticString = #file) -> some View {
        let name = String(String(file).split(separator: "/").last?.replacingOccurrences(of: ".swift", with: "") ?? "")
        return simulatorDebugFilename(name)
    }

    func simulatorDebugFilename(_ name: String) -> some View {
        modifier(DebugFilenameModifier(filename: name))
    }
}

struct DebugFilenameModifier: ViewModifier {
    private let filename: String

    init(filename: String) {
        self.filename = filename
    }

    @Environment(\.simulatorDebugFilename) private var debugFilename

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
    var simulatorDebugFilename: Bool {
        get {
            self[DebugFilenameEnvironmentKey.self]
        }
        set {
            self[DebugFilenameEnvironmentKey.self] = newValue
        }
    }
}
