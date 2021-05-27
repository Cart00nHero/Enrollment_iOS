//
//  AppActions.swift
//  Enrollment
//
//  Created by YuCheng on 2021/5/27.
//

import Foundation
import ReSwift

struct GetBase64ImageAction: Action {
    let base64Image: String
}

struct SendUnitInfoAction: Action {
    let info: VisitedUnit
    
}
