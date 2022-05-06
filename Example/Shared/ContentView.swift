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
    @State var isPresentedSheet = false
    @State var isPresentedSimulatableSheet = false

    @Environment(\.locale) var locale
    @Environment(\.calendar) var calendar
    @Environment(\.timeZone) var timeZone

    init() {
        if isFirstLaunch {
            defer { isFirstLaunch = false }

            struct User: Codable {
                let name: String
                let age: Int
                let date: Date
                let url: URL
            }

            //
            // UserDefaults.standard
            //
            let standard = UserDefaults.standard
            standard.set("Hello!", forKey: "message")
            standard.set(7.5, forKey: "number")
            standard.set(URL(string: "https://github.com/YusukeHosonuma/SwiftUI-Simulator")!, forKey: "url")
            standard.set(Date(), forKey: "date")
            standard.set(["Apple", "Orange"], forKey: "array")
            standard.set([
                "int": 42,
                "float": Float(3.14),
                "bool": true,
                "string": "String",
                "array": ["one", "two"],
            ], forKey: "dictionary")

            let user = User(
                name: "tobi462",
                age: 17,
                date: Date(),
                url: URL(string: "https://github.com/YusukeHosonuma/SwiftUI-Simulator")!
            )
            let data = try! JSONEncoder().encode(user)
            standard.set(data, forKey: "user")

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
                VStack {
                    Button(".sheet()") {
                        isPresentedSheet.toggle()
                    }

                    Button(".simulatableSheet()") {
                        isPresentedSimulatableSheet.toggle()
                    }
                }
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
        .sheet(isPresented: $isPresentedSheet) {
            SampleSheetView()
        }
        .simulatableSheet(isPresented: $isPresentedSimulatableSheet) {
            SampleSheetView()
        }
        .onAppear {
            state.onAppear()
        }
        .debugFilename()
    }
}

struct SampleSheetView: View {
    //
    // ☑️ Standard API (iOS 14+)
    //
    // @Environment(\.presentationMode) private var presentationMode
    //
    @DismissSheet private var dismiss

    var body: some View {
        //
        // ☑️ Not use `NavigationView`
        //
        // ZStack {
        //    Color.green//.opacity(0.1)
        //    VStack {
        //        Text("Top")
        //        Spacer()
        //        Text("Bottom")
        //    }
        // }
        // .border(.blue, width: 2)

        //
        // ☑️ Use `NavigationView`
        //
        NavigationView {
            VStack {
                Text("Top")
                Spacer()
                Text("This is sample sheet.")
                    .navigationTitle("Sheet")
                    .toolbar {
                        ToolbarItem(placement: .destructiveAction) {
                            Button("Done") {
                                //
                                // ☑️ Standard API (iOS 14+)
                                //
                                // presentationMode.wrappedValue.dismiss()
                                //
                                dismiss()
                            }
                        }
                    }
                Spacer()
                Text("Bottom")
            }
        }
        // FIXME: NavigationView の場合、勝手にセーフエリア（bottom）分の余白を追加してしまう
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
