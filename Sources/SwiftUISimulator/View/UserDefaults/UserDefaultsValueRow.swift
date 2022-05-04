//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/05/03.
//

import SwiftPrettyPrint
import SwiftUI

struct UserDefaultsValueRow: View {
    @Environment(\.simulatorAccentColor) private var simulatorAccentColor

    private var name: String
    private var defaults: UserDefaults
    private var key: String

    init(name: String, defaults: UserDefaults, key: String) {
        self.name = name
        self.defaults = defaults
        self.key = key
    }

    @State private var contentID = UUID() // for update view.
    @State private var isPresentedEditSheet = false

    private var value: String {
        if let _ = defaults.value(forKey: key) as? Data, let url = defaults.url(forKey: key) {
            return url.absoluteString
        } else {
            switch prettyString(defaults.value(forKey: key)) {
            case let .string(string):
                return string
            case let .json(pretty: string, rawString: _):
                return string
            }
        }
    }

    private var rawString: String? {
        switch prettyString(defaults.value(forKey: key)) {
        case .string:
            return nil
        case let .json(pretty: _, rawString: rawString):
            return rawString
        }
    }

    private var exportString: String {
        """

        \(key)

        \(value + (rawString.map { "\n" + $0 } ?? ""))
        """
    }

    var body: some View {
        GroupBox {
            HStack {
                VStack(alignment: .leading) {
                    Text(value)
                    if let rawString = rawString {
                        Text(rawString).foregroundColor(.gray)
                    }
                }
                Spacer()
            }
            .lineLimit(nil)
            .fixedSize(horizontal: false, vertical: true)
            .font(.system(size: 14, weight: .regular, design: .monospaced))
            .padding(.top, 2)
        } label: {
            HStack {
                Text(key)
                    .font(.system(size: 14, weight: .bold, design: .monospaced))
                    .lineLimit(1)
                    .foregroundColor(.gray)
                Spacer()

                Group {
                    //
                    // 􀈊 Edit
                    //
                    Button {
                        isPresentedEditSheet.toggle()
                    } label: {
                        Image(systemName: "pencil")
                    }

                    //
                    // 􀩼 Console
                    //
                    Button {
                        print(exportString)
                    } label: {
                        Image(systemName: "terminal")
                    }

                    //
                    // 􀉁 Copy
                    //
                    Button {
                        UIPasteboard.general.string = exportString
                    } label: {
                        Image(systemName: "doc.on.doc")
                    }
                }
                .font(.system(size: 14, weight: .regular))
            }
        }
        .id(contentID)
        .sheet(isPresented: $isPresentedEditSheet, onDismiss: { contentID = UUID() }) {
            UserDefaultsEditView(name: name, userDefaults: defaults, key: key)
                .accentColor(simulatorAccentColor)
        }
    }
}

private func prettyString(_ value: Any?) -> PrettyResult {
    guard let value = value else { return .string("nil") }

    var option = Pretty.sharedOption
    option.indentSize = 2

    var output = ""

    if let string = value as? String {
        //
        // 💡 Try decode as JSON. (For data that encoded by `JSONEncoder`)
        //
        // e.g.
        // `{"rawValue":{"red":0,"alpha":1,"blue":0,"green":0}}`
        //
        if string.hasPrefix("{"), string.hasSuffix("}"), let dict = string.jsonToDictionary() {
            Pretty.prettyPrintDebug(dict, option: option, to: &output)
            return .json(pretty: output, rawString: string)
        }
    }

    Pretty.prettyPrintDebug(value, option: option, to: &output)
    return .string(output)
}

private enum PrettyResult {
    case string(String)
    case json(pretty: String, rawString: String)
}
