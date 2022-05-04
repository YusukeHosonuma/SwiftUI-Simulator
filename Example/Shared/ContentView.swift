//
//  ContentView.swift
//  Shared
//
//  Created by Yusuke Hosonuma on 2022/04/18.
//

import Combine
import SwiftUI

struct ContentView: View {
    @AppStorage("isFirstLaunch") private var isFirstLaunch = true
    @ObservedObject private var state: ContentState = .shared

    @State var dateStyle: DateFormatter.Style = .medium
    @State var timeStyle: DateFormatter.Style = .medium

    @Environment(\.locale) var locale
    @Environment(\.calendar) var calendar
    @Environment(\.timeZone) var timeZone

    init() {
        if isFirstLaunch {
            defer { isFirstLaunch = false }

            //
            // UserDefaults.standard
            //
            UserDefaults.standard.set("Hello!", forKey: "message")
            UserDefaults.standard.set(7.5, forKey: "number")
            UserDefaults.standard.set(URL(string: "https://github.com/YusukeHosonuma/SwiftUI-Simulator")!, forKey: "url")
            UserDefaults.standard.set(Date(), forKey: "date")
            UserDefaults.standard.set([
                "int": 42,
                "float": Float(3.14),
                "bool": true,
                "string": "String",
                "array": ["one", "two"],
            ], forKey: "dictionary")

            //
            // AppGroup
            //
            guard let group = UserDefaults(suiteName: groupID) else { preconditionFailure() }
            group.set("Goodbye.", forKey: "message")
            group.set(42.195, forKey: "number")
        }
    }

    private var dateFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateStyle = dateStyle
        f.timeStyle = timeStyle
        f.locale = locale
        f.calendar = calendar
        f.timeZone = timeZone
        return f
    }

    var body: some View {
        NavigationView {
            VStack {
                //
                // Message
                //
                MessageView()

                //
                // Test for accentColor
                //
                Button("Hello") {}
                    .font(.title3)

                //
                // Date style
                //
                HStack {
                    Text(LocalizedStringKey("date"))
                    Picker("", selection: $dateStyle) {
                        ForEach(DateFormatter.Style.allCases) { style in
                            Text("\(style.label)").tag(style)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                //
                // Time style
                //
                HStack {
                    Text(LocalizedStringKey("time"))
                    Picker("", selection: $timeStyle) {
                        ForEach(DateFormatter.Style.allCases) { style in
                            Text("\(style.label)").tag(style)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                //
                // Current time
                //
                Text("\(dateFormatter.string(from: state.currentTime))")
                    .font(.title2)
                    .padding()
            }
            .padding()
            .navigationTitle("SwiftUI-Simulator")
        }
        .navigationViewStyle(.stack)
        .onAppear {
            state.onAppear()
        }
        .debugFilename()
    }
}

final class ContentState: ObservableObject {
    @Published var currentTime: Date = .init()

    private var cancellables: Set<AnyCancellable> = []

    static let shared: ContentState = .init()

    func onAppear() {
        Timer.publish(every: 1, on: .current, in: .common)
            .autoconnect()
            .sink { _ in
                self.currentTime = .init() // ⏰ Update to current time
            }
            .store(in: &cancellables)
    }
}

extension DateFormatter.Style: CaseIterable, Identifiable {
    public static var allCases: [DateFormatter.Style] = [
        .none,
        .short,
        .medium,
        .long,
        .full,
    ]

    public var id: String { label }

    var label: String {
        switch self {
        case .none: return "none"
        case .short: return "short"
        case .medium: return "medium"
        case .long: return "long"
        case .full: return "ful"
        @unknown default:
            preconditionFailure()
        }
    }
}
