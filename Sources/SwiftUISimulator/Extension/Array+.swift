//
//  File.swift
//
//
//  Created by Yusuke Hosonuma on 2022/04/14.
//

import Foundation

extension Array where Element: Equatable {
    func prev(_ element: Element) -> Element? {
        if let index = firstIndex(of: element), indices.contains(index - 1) {
            return self[index - 1]
        } else {
            return nil
        }
    }

    func next(_ element: Element) -> Element? {
        if let index = firstIndex(of: element), indices.contains(index + 1) {
            return self[index + 1]
        } else {
            return nil
        }
    }
}

extension Array where Element == Any {
    static func from(jsonString: String) -> [Any]? {
        guard
            let data = jsonString.data(using: .utf8),
            let decoded = try? JSONSerialization.jsonObject(with: data),
            let array = decoded as? [Any] else { return nil }

        return array
    }

    var prettyJSON: String {
        let jsonData = try? JSONSerialization.data(
            withJSONObject: self,
            options: [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
        )
        return String(data: jsonData!, encoding: .utf8)!
    }
}
