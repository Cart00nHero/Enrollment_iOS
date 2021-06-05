//
//  LittleKit.swift
//  Enrollment
//
//  Created by YuCheng on 2021/5/30.
//

import Foundation
import SwiftUI

func localized(_ key: String) -> String {
    return NSLocalizedString(key, comment: "")
}
func autoUISize(_ value: CGFloat) -> CGFloat {
    return value * UIScreen.main.bounds.width/375.0
}
func autoFont(value: CGFloat) -> CGFloat {
    if UIScreen.main.bounds.width < 375.0 {
        return (value - 2.0)
    }
    if UIScreen.main.bounds.width > 375.0 {
        return (value + 2.0)
    }
    return value
}

let screenSize = UIScreen.main.bounds.size
let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height

