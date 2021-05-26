//
//  QRCodeScenario.swift
//  Enrollment
//
//  Created by YuCheng on 2021/5/27.
//

import Foundation
import Flynn
import UIKit

class QRCodeScenario: Actor {
    private func _beResizeImage(image: UIImage) {
        ToolMan().beResizeImage(sender: self, image: image, width: <#T##CGFloat#>, <#T##complete: (UIImage) -> Void##(UIImage) -> Void#>)
    }
}
