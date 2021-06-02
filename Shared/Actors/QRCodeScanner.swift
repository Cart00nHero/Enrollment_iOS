//
//  QRCodeScanner.swift
//  Enrollment
//
//  Created by YuCheng on 2021/6/2.
//

import Foundation
import UIKit
import Flynn

class QRCodeScanner: Actor {
    
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
    private func _beConvertQRSMS(
        sender:Actor,smsText: String,
        _ complete:@escaping (_ success: Bool, _ smsText: String) -> Void) {
        let tempText = smsText
        if tempText.lowercased().hasPrefix("smsto") {
            let splitArray = smsText.split(separator: ":")
            if splitArray.count >= 3 {
                let sliceArr = splitArray[2 ..< splitArray.count]
                let bodyText = NSMutableString()
                for text in sliceArr {
                    bodyText.append(String(text))
                }
                let sendSMSText = "sms:\(splitArray[1])&body=\(bodyText)"
                sender.unsafeSend {
                    complete(true,sendSMSText)
                }
                return
            }
        }
        sender.unsafeSend {
            complete(false,smsText)
        }
    }
}

// MARK: - Autogenerated by FlynnLint
// Contents of file after this marker will be overwritten as needed

extension QRCodeScanner {

    @discardableResult
    public func beDecodeQrCode(sender: Actor, image: UIImage, _ complete: @escaping([String]) -> Void) -> Self {
        unsafeSend { self._beDecodeQrCode(sender: sender, image: image, complete) }
        return self
    }
    @discardableResult
    public func beConvertQRSMS(sender: Actor, smsText: String, _ complete: @escaping (_ success: Bool, _ smsText: String) -> Void) -> Self {
        unsafeSend { self._beConvertQRSMS(sender: sender, smsText: smsText, complete) }
        return self
    }

}
