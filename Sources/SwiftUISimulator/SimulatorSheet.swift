//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/05/02.
//

import SwiftUI

public extension View {
    func simulatedSheet<Content: View>(
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        modifier(SimulatorSheetModifier(sheetContent: content, isPresented: isPresented))
    }
}

struct SimulatorSheetModifier<SheetContent: View>: ViewModifier {
    @EnvironmentObject private var model: SimulatorSheetModel
    @Environment(\.simulatorEnabled) private var isSimulatorEnabled
    @Environment(\.simulatedDevice) var simulatedDevice

    let sheetContent: () -> SheetContent
    @Binding var isPresented: Bool

    func body(content: Content) -> some View {
        if isSimulatorEnabled, let _ = simulatedDevice {
            content
                .onChange(of: isPresented) { _ in
                    update()
                }
        } else {
            content
                .sheet(isPresented: $isPresented, content: sheetContent)
        }
    }

    private func update() {
        model.update(
            content: AnyView(sheetContent()),
            isPresentedBinding: _isPresented
        )
    }
}

final class SimulatorSheetModel: ObservableObject {
    @Published var isPresented = false
    @Published var content: AnyView = .init(EmptyView())

    var isPresentedBinding: Binding<Bool>?

    func update(
        content: AnyView,
        isPresentedBinding: Binding<Bool>
    ) {
        self.content = content
        isPresented = isPresentedBinding.wrappedValue
        self.isPresentedBinding = isPresentedBinding
    }
}

// 🌱 Special Thanks.
// https://github.com/franklynw/HalfASheet
// https://github.com/AndreaMiotto/PartialSheet

struct SimulatorSheet: View {
    @EnvironmentObject var model: SimulatorSheetModel
    @Environment(\.simulatedDevice) var simulatedDevice

    @State private var hasAppeared = false
    @State private var dragOffset: CGFloat = 0

    private let cornerRadius: CGFloat = 15

    var body: some View {
        ZStack {
            //
            // Background
            //
            if model.isPresented {
                Color.black.opacity(0.15)
                    .transition(.opacity)
                    .onAppear {
                        withAnimation {
                            hasAppeared = true
                        }
                    }
            }

            if hasAppeared {
                VStack(spacing: 0) {
                    Spacer(minLength: 0)

                    //
                    // Sheet
                    //
                    ZStack {
                        //
                        // Content
                        //
                        model.content
                            // ⚠️ FIXME: Temporary measures (AutoLayout errors when use NavigationView)
                            .navigationViewStyle(.stack)
                            .padding(.bottom, safeAreaBottom)
                            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                            .environment(\.simulatedSheetDismiss) { dismiss() }
                    }
                    .frame(width: sheetSize.width, height: sheetSize.height)
                    // .offset(y: dragOffset + (safeAreaBottom / 2))
                    .offset(y: dragOffset)
                }
                .transition(.verticalSlide(sheetSize.height))
                .highPriorityGesture(
                    dragGesture()
                )
                .onDisappear {
                    dragOffset = 0
                }
            }
        }
        .ignoresSafeArea(edges: [.top, .bottom])
    }

    private var safeAreaBottom: CGFloat {
        if let device = simulatedDevice {
            return device.info.safeArea.portrait.bottom
        } else {
            return 0
        }
    }

    private var sheetSize: CGSize {
        if let device = simulatedDevice {
            return CGSize(width: device.info.size.width, height: device.info.size.height * 0.94)
        } else {
            return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.94)
        }
    }

    private func dragGesture() -> some Gesture {
        DragGesture()
            .onChanged {
                let offset = $0.translation.height
                dragOffset = offset > 0 ? offset : 0
            }
            .onEnded {
                if dragOffset > 0, ($0.predictedEndTranslation.height / $0.translation.height) > 2.0 {
                    dismiss()
                    return
                }

                withAnimation {
                    dragOffset = 0
                }
            }
    }

    private func dismiss() {
        withAnimation {
            hasAppeared = false
            model.isPresented = false
            model.isPresentedBinding?.wrappedValue = false
        }
    }
}
