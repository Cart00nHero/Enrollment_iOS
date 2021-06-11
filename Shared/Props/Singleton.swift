//
//  SingletonStorage.swift
//  Enrollment
//
//  Created by YuCheng on 2021/5/27.
//

import Foundation
import SwiftUI
import UIKit
class Singleton: NSObject {
    static let shared = Singleton()
    var currentRole = ""
}
let roleStoredKey = "role_of_user"

let serviceType = "visitor-record"
