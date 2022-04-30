//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/04/29.
//

// import SwiftUI
//
// public struct CatalogItemView: View {
//    var name: String
//    var item: () -> AnyView
//
//    public init(
//        name: String,
//        @ViewBuilder item: @escaping () -> AnyView
//    ) {
//        self.name = name
//        self.item = item
//    }
//
//    public var body: some View {
//        VStack {
//            Text(name)
//                .font(.title)
//            item()
//        }
//    }
// }
//
// struct CatalogListView: View {
//    @Environment(\.presentationMode) private var presentationMode
//
//    let items: [CatalogItemView]
//
//    var devices: [Device] = [
//        .iPodTouch,
//        .iPhoneSE,
//        .iPhone11Pro
//    ]
//
//    var body: some View {
//        NavigationView {
//            ForEach(items, id: \.name) { item in
//                TabView {
//                    ForEach(devices) { device in
//                        VStack {
//                            Text("\(device.name)")
//                            HStack {
//                                item.item()
//                                    .border(.red)
//                                    .environment(\.colorScheme, .dark)
//                                    .frame(width: device.info.size.width, height: device.info.size.height)
//                                item.item()
//                                    .border(.red)
//                                    .environment(\.colorScheme, .light)
//                                    .frame(width: device.info.size.width, height: device.info.size.height)
//                            }
//                        }
//                        .padding()
//                    }
//                }
//                .tabViewStyle(PageTabViewStyle())
//            }
//            .toolbar {
//                ToolbarItem(placement: .destructiveAction) {
//                    Button("Close") {
//                        presentationMode.wrappedValue.dismiss()
//                    }
//                }
//            }
//        }
//    }
// }
//
////struct CatalogView_Previews: PreviewProvider {
////    static var previews: some View {
////        CatalogListView {
////            CatalogItemView(name: "Row") {
////
////                Row(title: "foo", description: "bar")
////                Row(title: "hoge", description: "fuga")
////            }
////        }
////    }
////}
//
// struct Row: View {
//    let title: String
//    let description: String
//
//    var body: some View {
//        VStack {
//            Text(title)
//                .font(.headline)
//            Text(description)
//        }
//    }
// }
