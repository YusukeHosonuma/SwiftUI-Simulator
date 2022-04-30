//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/04/30.
//

import SwiftUI

public struct CatalogItem: Identifiable {
    public let id = UUID()

    let title: String
    let description: String
    let template: String?
    let content: () -> AnyView

    public init(title: String, description: String, template: String? = nil, content: @escaping () -> AnyView) {
        self.title = title
        self.description = description
        self.template = template
        self.content = content
    }
}
