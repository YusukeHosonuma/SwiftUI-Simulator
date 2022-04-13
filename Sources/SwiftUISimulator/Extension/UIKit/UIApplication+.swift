//
//  File.swift
//  
//
//  Created by Yusuke Hosonuma on 2022/04/13.
//

import UIKit

public extension UIApplication {
    static func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
