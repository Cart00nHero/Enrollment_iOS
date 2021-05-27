//
//  SingletonStorage.swift
//  Enrollment
//
//  Created by YuCheng on 2021/5/27.
//

import Foundation
class SingletonStorage: NSObject {
    static let shared = SingletonStorage()
    var currentRole = ""
    
}
let serviceType = "visitor-record"
