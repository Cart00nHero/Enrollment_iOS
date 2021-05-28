//
//  UIActions.swift
//  Enrollment
//
//  Created by YuCheng on 2021/5/21.
//

import Foundation
import ReSwift
import UIKit

struct ListTextFieldOnChangeAction: Action {
    let index: Int
    let newValue: String
}
struct ReceivedInitationAction: Action {
    let source: [ListInputItem]
}
struct OpenFormURLAction: Action {
    let urlString: String
}
struct GetPickerImageAction: Action {
    let image: UIImage
}
struct SwitchTabAction: Action {
    let tabIndex: Int
}
