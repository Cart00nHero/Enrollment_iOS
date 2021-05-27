//
//  SingletonStorage.swift
//  Enrollment
//
//  Created by YuCheng on 2021/5/27.
//

import Foundation
import SwiftUI
import UIKit
class SingletonStorage: NSObject {
    static let shared = SingletonStorage()
    var currentRole = ""
}

let serviceType = "visitor-record"
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
