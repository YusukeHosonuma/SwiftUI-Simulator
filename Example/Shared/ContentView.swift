//
//  ContentView.swift
//  Shared
//
//  Created by Yusuke Hosonuma on 2022/04/18.
//

import SwiftUI
import Combine

struct ContentView: View {
    @ObservedObject private var state: ContentState = .shared

    @State var dateStyle: DateFormatter.Style = .medium
    @State var timeStyle: DateFormatter.Style = .medium

    @Environment(\.locale) var locale
    @Environment(\.calendar) var calendar

    init() {}
    
    private var dateFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateStyle = dateStyle
        f.timeStyle = timeStyle
        f.locale = locale
        f.calendar = calendar
        return f
    }

    var body: some View {
        NavigationView {
            VStack {
                //
                // Message
                //
                Text(LocalizedStringKey("message"))
                    .padding(.bottom, 64)
                
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
                if let time = state.currentTime {
                    Text("\(dateFormatter.string(from: time))")
                        .font(.title2)
                        .padding()
                }
            }
            .padding()
            .navigationTitle("SwiftUI-Simulator")
        }
        .navigationViewStyle(.stack)
        .onAppear {
            state.onAppear()
        }
    }
}

final class ContentState: ObservableObject {
    @Published var currentTime: Date?
    
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
        .full
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
