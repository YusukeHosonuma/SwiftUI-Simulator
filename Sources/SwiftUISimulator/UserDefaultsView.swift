//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/05/01.
//

import SwiftPrettyPrint
import SwiftUI

struct UserDefaultsView: View {
    let userDefaults: UserDefaults
    let keys: [String]

    @State private var searchText = ""

    private var defaultsDictionary: [String: Any] {
        userDefaults.dictionaryRepresentation()
    }

    private var filteredKeys: [String] {
        if searchText.isEmpty {
            return keys
        } else {
            return keys.filter { $0.localizedStandardContains(searchText) }
        }
    }

    var body: some View {
        VStack {
            SearchTextField("Search by key...", text: $searchText)
                .padding(.horizontal)
            ScrollView {
                if filteredKeys.isEmpty {
                    Text("No results.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    VStack(alignment: .leading) {
                        ForEach(filteredKeys.sorted(), id: \.self) { key in
                            group(key: key, prettyResult: prettyString(defaultsDictionary[key]))
                        }
                    }
                    .padding()
                }
            }
        }
    }

    private func group(key: String, prettyResult: PrettyResult) -> some View {
        let pretty: String
        let raw: String?

        switch prettyResult {
        case let .string(string):
            pretty = string
            raw = nil
        case let .json(pretty: string, rawString: rawString):
            pretty = string
            raw = rawString
        }

        let exportString = """
        
        \(key)
        
        \(pretty + (raw.map { "\n" + $0 } ?? ""))
        """

        return GroupBox {
            HStack {
                VStack(alignment: .leading) {
                    Text(pretty)
                    if let raw = raw {
                        Text(raw).foregroundColor(.gray)
                    }
                }
                Spacer()
            }
            .lineLimit(nil)
            .font(.system(size: 16, weight: .regular, design: .monospaced))
            .padding(.top, 2)
        } label: {
            HStack {
                Text(key)
                Spacer()

                //
                // 􀩼
                //
                Button {
                    print(exportString)
                } label: {
                    Image(systemName: "terminal")
                }

                //
                // 􀉁
                //
                Button {
                    UIPasteboard.general.string = exportString
                } label: {
                    Image(systemName: "doc.on.doc")
                }
            }
        }
    }

    private func prettyString(_ value: Any?) -> PrettyResult {
        guard let value = value else { return .string("nil") }

        var output = ""

        if let string = value as? String {
            //
            // 💡 Try decode as JSON. (For data that encoded by `JSONEncoder`)
            //
            // e.g.
            // `{"rawValue":{"red":0,"alpha":1,"blue":0,"green":0}}`
            //
            if string.hasPrefix("{"), string.hasSuffix("}"), let dict = string.jsonToDictionary() {
                Pretty.prettyPrintDebug(dict, to: &output)
                return .json(pretty: output, rawString: string)
            }
        }

        Pretty.prettyPrintDebug(value, to: &output)
        return .string(output)
    }
}

private enum PrettyResult {
    case string(String)
    case json(pretty: String, rawString: String)
}
