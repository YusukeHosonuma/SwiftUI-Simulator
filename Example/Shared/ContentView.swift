//
//  ContentView.swift
//  Shared
//
//  Created by Yusuke Hosonuma on 2022/04/18.
//

import Combine
import SwiftUI

struct ContentView: View {
    @ObservedObject private var state: ContentState = .shared

    @State var dateStyle: DateFormatter.Style = .medium
    @State var timeStyle: DateFormatter.Style = .medium
    @State var isPresentedSheet = false
    @State var isPresentedSimulatableSheet = false

    @Environment(\.locale) var locale
    @Environment(\.calendar) var calendar
    @Environment(\.timeZone) var timeZone

    init() {}

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

extension View {
    func simulatableSheet<Content: View>(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) -> some View {
        #if DEBUG
        simulatedSheet(isPresented: isPresented, content: content)
        #else
        sheet(isPresented: isPresented, content: content)
        #endif
    }
}

struct SampleSheetView: View {
    @Environment(\.presentationMode) private var presentationMode
    #if DEBUG
    @Environment(\.simulatedSheetDismiss) private var dismiss
    #endif

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
                                presentationMode.wrappedValue.dismiss()
                                #if DEBUG
                                dismiss()
                                #endif
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
