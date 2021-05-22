//
//  Entities.swift
//  Enrollment
//
//  Created by YuCheng on 2021/5/21.
//

import Foundation
import SwiftUI

struct ListInputItem: Hashable {
    var title = ""
    var placeholder = ""
    var keyboardType: UIKeyboardType = .default
    var content = ""
}

struct VisitorInfo: Convertable {
    var name = ""
    var tel = ""
    var identityNo = ""
}
struct VisitedUnit: Convertable {
    var code = ""
    var name = ""
    var cloudForm = ""
}

struct TabPageItem {
    let pageView: AnyView
    var tabImage: Image = Image(systemName: "bubble.left")
    var title = ""
}
