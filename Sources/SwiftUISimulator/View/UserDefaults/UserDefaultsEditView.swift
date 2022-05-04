//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/05/03.
//

import SwiftUI

enum ValueType: Identifiable, CaseIterable {
    case string
    case bool
    case int
    case float
    case double
    case url
    case date
    case array
    case dictionary
    case unknown

    var typeName: String {
        switch self {
        case .string: return "String"
        case .bool: return "Bool"
        case .int: return "Int"
        case .float: return "Float"
        case .double: return "Double"
        case .url: return "URL"
        case .date: return "Date"
        case .array: return "[Any]"
        case .dictionary: return "[String: Any]"
        case .unknown: return "(Unkonwn)"
        }
    }

    var id: String { typeName }
}

struct UserDefaultsEditView: View {
    // 💡 iOS 15+: `\.dismiss`
    @Environment(\.presentationMode) private var presentationMode

    private let name: String
    private let userDefaults: UserDefaults
    private let key: String

    init(name: String, userDefaults: UserDefaults, key: String) {
        self.name = name
        self.userDefaults = userDefaults
        self.key = key
    }

    @State private var valueType: ValueType = .string
    
    @State private var valueBool: Bool = false
    @State private var valueInt: Int = 0
    @State private var valueFloat: Float = 0
    @State private var valueDouble: Double = 0
    @State private var valueString: String = ""
    @State private var valueURL: URL? = nil
    @State private var valueDate: Date? = nil
    @State private var valueArray: [Any] = []
    @State private var valueDictionary: [String: Any] = [:]

    @State private var isValid = true
    @State private var isPresentedConfirmDelete = false

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("\(key): \(valueType.typeName)")
                    .font(.system(size: 14, weight: .bold, design: .monospaced))
                    .foregroundColor(.gray)
                    .lineLimit(1)
                    .padding(.horizontal)

                valueEditor()
            }
            .navigationTitle(name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .destructiveAction) {
                    Button("Save") {
                        save()
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(valueType == .unknown || isValid == false)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        Button {
                            isPresentedConfirmDelete.toggle()
                        } label: {
                            Image(systemName: "trash")
                        }
                        Spacer()
                    }
                }
            }
        }
        .onAppear {
            load()
        }
        //
        // ⚠️ Delete Key?
        //
        .alert(isPresented: $isPresentedConfirmDelete) {
            Alert(
                title: Text("Delete Key?"),
                message: Text("Are you delete '\(key)'?"),
                primaryButton: .cancel(),
                secondaryButton: .destructive(Text("Delete"), action: {
                    delete()
                    presentationMode.wrappedValue.dismiss()
                })
            )
        }
    }
    
    // MARK: Editor

    @ViewBuilder
    private func valueEditor() -> some View {
        switch valueType {
        case .bool:
            UserDefaultsBoolEditor(value: $valueBool)
                .padding([.horizontal, .bottom])

        case .string:
            TextEditor(text: $valueString)
                .style(.valueEditor)
                .padding([.horizontal, .bottom])

        case .int:
            UserDefaultsStringEditor($valueInt, isValid: $isValid)

        case .float:
            UserDefaultsStringEditor($valueFloat, isValid: $isValid)

        case .double:
            UserDefaultsStringEditor($valueDouble, isValid: $isValid)

        case .url:
            if let url = valueURL {
                UserDefaultsStringEditor(.init(
                    get: { url },
                    set: { valueURL = $0 }
                ), isValid: $isValid, style: .multiline)
                    .padding(.bottom)
            }

        case .date:
            if let date = valueDate {
                UserDefaultsStringEditor(.init(
                    get: { date },
                    set: { valueDate = $0 }
                ), isValid: $isValid)
            }

        case .array:
            VStack {
                UserDefaultsStringEditor(.init(
                    get: { ArrayWrapper(valueArray) },
                    set: { valueArray = $0.array }
                ), isValid: $isValid, style: .multiline)
                Text("Please input as JSON.")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding(.bottom)
            }
            
        case .dictionary:
            VStack {
                UserDefaultsStringEditor(.init(
                    get: { DictionaryWrapper(valueDictionary) },
                    set: { valueDictionary = $0.dictionary }
                ), isValid: $isValid, style: .multiline)
                Text("Please input as JSON.")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding(.bottom)
            }

        case .unknown:
            VStack(spacing: 16) {
                Text("This type was not supported yet.")
                Text("Contributions are welcome!")
                Link("YusukeHosonuma/SwiftUI-Simulator",
                     destination: URL(string: "https://github.com/YusukeHosonuma/SwiftUI-Simulator")!)
            }
            .font(.system(size: 14, weight: .regular, design: .monospaced))
            .padding()
        }
    }

    // MARK: Load / Save

    private func load() {
        let value = userDefaults.value(forKey: key)

        switch value {
        case let value as Bool:
            valueType = .bool
            valueBool = value

        case let value as Int:
            valueType = .int
            valueInt = value

        case let value as Float:
            valueType = .float
            valueFloat = value

        case let value as Double:
            valueType = .double
            valueDouble = value

        case let value as String:
            valueType = .string
            valueString = value

        case let value as [Any]:
            valueType = .array
            valueArray = value

        case let value as [String: Any]:
            valueType = .dictionary
            valueDictionary = value
            
        default:
            //
            // 💡 Note:
            // The `URL` type was stored by encoded `Data`.
            // Therefore must use `url(forKey:)`.
            //
            if let url = userDefaults.url(forKey: key) {
                valueType = .url
                valueURL = url
            } else {
                let object = userDefaults.object(forKey: key)

                switch object {
                case let value as Date:
                    valueType = .date
                    valueDate = value
                default:
                    valueType = .unknown
                    print("type: \(String(describing: object.self))")
                }
            }
        }
    }

    private func save() {
        switch valueType {
        case .string:
            userDefaults.set(valueString, forKey: key)
        case .bool:
            userDefaults.set(valueBool, forKey: key)
        case .int:
            userDefaults.set(valueInt, forKey: key)
        case .float:
            userDefaults.set(valueFloat, forKey: key)
        case .double:
            userDefaults.set(valueDouble, forKey: key)
        case .url:
            userDefaults.set(valueURL, forKey: key)
        case .date:
            userDefaults.set(valueDate, forKey: key)
        case .array:
            userDefaults.set(valueArray, forKey: key)
        case .dictionary:
            userDefaults.set(valueDictionary, forKey: key)
        case .unknown:
            return
        }
    }
    
    private func delete() {
        userDefaults.removeObject(forKey: key)
    }
}
