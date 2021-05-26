//
//  ToolMan.swift
//  WhatToEat
//
//  Created by YuCheng on 2021/3/3.
//  Copyright © 2021 YuCheng. All rights reserved.
//

import Foundation
import UIKit
import Flynn

class ToolMan: Actor {
    private func _beResizeImage(
        sender: Actor,image: UIImage, newSize: CGSize,
        _ complete: @escaping (UIImage) -> Void) {
        let size = newSize
        let renderer = UIGraphicsImageRenderer(size: size)
        let newImage = renderer.image { (context) in
            image.draw(in: renderer.format.bounds)
        }
        sender.unsafeSend {
            complete(newImage)
        }
    }
    private func _beBase64ImageString(
        sender: Actor,image: UIImage,
        _ complete:@escaping(String) -> Void) {
        /*
         //jpeg格式 compressionQuality: 压缩质量
         guard let imageData = image.jpegData(compressionQuality: 1) else {
         return
         }*/
        //png格式
        guard let imageData = image.pngData() else {
            return
        }
        let base64ImageStr =
            imageData.base64EncodedString(options: .lineLength64Characters)
        sender.unsafeSend {
            complete(base64ImageStr)
        }
    }
    private func _beDecodeQrCode(
        sender:Actor, image: UIImage,
        _ complete:@escaping([String]) -> Void) {
        var messages: [String] = []
        if let features = detectQRCode(image), !features.isEmpty{
            for case let row as CIQRCodeFeature in features{
                let qrcodeMsg = row.messageString ?? ""
                if !qrcodeMsg.isEmpty {
                    messages.append(qrcodeMsg)
                }
            }
            if messages.count > 0 {
                sender.unsafeSend {
                    complete(messages)
                }
            }
        }
    }
    
    private func detectQRCode(_ image: UIImage?) -> [CIFeature]? {
        if let image = image, let ciImage = CIImage.init(image: image){
            var options: [String: Any]
            let context = CIContext()
            options = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
            let qrDetector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: options)
            if ciImage.properties.keys.contains((kCGImagePropertyOrientation as String)){
                options = [CIDetectorImageOrientation: ciImage.properties[(kCGImagePropertyOrientation as String)] ?? 1]
            } else {
                options = [CIDetectorImageOrientation: 1]
            }
            let features = qrDetector?.features(in: ciImage, options: options)
            return features
            
        }
        return nil
    }
}
