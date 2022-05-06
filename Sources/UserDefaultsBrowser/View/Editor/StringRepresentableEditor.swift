//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/05/03.
//

import SwiftUI

protocol StringEditable {
    init?(_ string: String)
    func toString() -> String
}

extension Int: StringEditable {
    func toString() -> String {
        "\(self)"
    }
}

extension Float: StringEditable {
    func toString() -> String {
        "\(self)"
    }
}

extension Double: StringEditable {
    func toString() -> String {
        "\(self)"
    }
}

extension URL: StringEditable {
    init?(_ string: String) {
        self.init(string: string)
    }

    func toString() -> String {
        absoluteString
    }
}

extension Date: StringEditable {
    init?(_ string: String) {
        if let date = Self.formatter.date(from: string) {
            self = date
        } else {
            return nil
        }
    }

    func toString() -> String {
        Self.formatter.string(from: self)
    }

    static var formatter: ISO8601DateFormatter {
        let f = ISO8601DateFormatter()
        f.timeZone = .current
        return f
    }
}

struct ArrayWrapper: StringEditable {
    let array: [Any]

    init(_ array: [Any]) {
        self.array = array
    }

    init?(_ string: String) {
        if let array = [Any].from(jsonString: string) {
            self.init(array)
        } else {
            return nil
        }
    }

    func toString() -> String {
        array.prettyJSON
    }
}

struct DictionaryWrapper: StringEditable {
    let dictionary: [String: Any]

    init(_ dictionary: [String: Any]) {
        self.dictionary = dictionary
    }

    init?(_ string: String) {
        if let dict = [String: Any].from(jsonString: string) {
            self.init(dict)
        } else {
            return nil
        }
    }

    func toString() -> String {
        dictionary.prettyJSON
    }
}

struct StringRepresentableEditor<Value: StringEditable>: View {
    enum Style {
        case single
        case multiline
    }

    @Binding private var value: Value
    @Binding private var isValid: Bool
    @State private var text: String = ""

    private let style: Style

    init(_ value: Binding<Value>, isValid: Binding<Bool>, style: Style = .single) {
        _value = value
        _isValid = isValid
        self.style = style
    }

    var body: some View {
        Group {
            switch style {
            case .single:
                TextField("", text: $text)
                    .style(.valueEditor)

            case .multiline:
                TextEditor(text: $text)
                    .style(.valueEditor)
            }
        }
        .padding([.horizontal])
        .onChange(of: text) {
            if let newValue = Value($0) {
                value = newValue
                isValid = true
            } else {
                isValid = false
            }
        }
        .onAppear {
            self.text = value.toString()
        }
    }
}
