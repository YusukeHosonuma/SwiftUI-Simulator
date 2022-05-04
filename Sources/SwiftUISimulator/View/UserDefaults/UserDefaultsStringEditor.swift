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

struct UserDefaultsStringEditor<Value: StringEditable>: View {
    @Binding var value: Value
    @Binding var isValid: Bool
    @State var text: String = ""

    init(_ value: Binding<Value>, isValid: Binding<Bool>) {
        _value = value
        _isValid = isValid
    }

    var body: some View {
        TextField("", text: $text)
            .padding()
            .border(.gray.opacity(0.5))
            .padding(.horizontal)
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
