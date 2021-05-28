//
//  QRCodeScenario.swift
//  Enrollment
//
//  Created by YuCheng on 2021/5/27.
//

import Foundation
import Flynn
import ReSwift
import UIKit

class QRCodeScenario: Actor {
    private let redux = ReduxActor()
    private lazy var unitInfo = VisitedUnit()
    private var receivedQrCodeEvent:((UIImage) -> Void)?
    
    private func _beSubscribeQRCode(
        _ complate:@escaping(UIImage) -> Void) {
        Courier().beClaim(recipient: self) { [self] pSet in
            for parcel in pSet {
                if let parcel = parcel as? Parcel<VisitedUnit> {
                    unitInfo = parcel.content
                    beConvertBase64Image { image in
                        DispatchQueue.main.async {
                            complate(image)
                        }
                    }
                }
            }
        }
    }
    
    private func _bePrePareQRCodeMessage(image: UIImage) {
        var qr_image = image
        var isResizing = false
        if image.size.width > 200.0 || image.size.height > 200.0 {
            isResizing = true
            ToolMan().beResizeImage(
                sender: self, image: image,
                newSize: CGSize(width: 200.0, height: 200.0)) { newImage in
                qr_image = newImage
                isResizing = false
            }
        }
        while isResizing {
            RunLoop.current.run(until: Date())
        }
        ToolMan().beBase64ImageString(sender: self, image: qr_image) { base64Str in
            appStore.dispatch(GetBase64ImageAction(base64Image: base64Str))
        }
    }
    
    private func _beScanQrCode(
        image: UIImage,_ complete:@escaping ([String]) -> Void) {
        ToolMan().beDecodeQrCode(sender: self, image: image) { messages in
            let qrURL = URL(string: messages.first ?? "Nothing")!
            qrURL.isReachable { reachable in
                if reachable {
                    Courier().beApplyExpress(
                        sender: self,
                        recipient: "WebViewScenario", content: qrURL, nil)
                    return
                }
                DispatchQueue.main.async {
                    if UIApplication.shared.canOpenURL(qrURL) {
                        UIApplication.shared.open(qrURL, options: [:], completionHandler: nil)
                    }
                }
            }
            DispatchQueue.main.async {
                complete(messages)
            }
        }
    }
    private func _beConvertBase64Image(
        _ complete:@escaping (UIImage) -> Void ) {
        ToolMan().beBase64ToImage(
            sender: self, strBase64: unitInfo.qrB64Image) { image in
            DispatchQueue.main.async {
                complete(image)
            }
        }
    }
    private func _beSubscribeRedux(
        _ complete:@escaping (SceneState) -> Void) {
        redux.subscribeRedux { [self] state in
            unsafeSend {
                switch state.currentAction {
                case let action as GetPickerImageAction:
                    bePrePareQRCodeMessage(image: action.image)
                default:
                    DispatchQueue.main.async {
                        complete(state)
                    }
                }
            }
        }
    }
    
    private func _beUnSubscribe() {
        redux.unsubscribe()
    }
}

// MARK: - Autogenerated by FlynnLint
// Contents of file after this marker will be overwritten as needed

extension QRCodeScenario {

    @discardableResult
    public func beSubscribeQRCode(_ complate: @escaping(UIImage) -> Void) -> Self {
        unsafeSend { self._beSubscribeQRCode(complate) }
        return self
    }
    @discardableResult
    public func bePrePareQRCodeMessage(image: UIImage) -> Self {
        unsafeSend { self._bePrePareQRCodeMessage(image: image) }
        return self
    }
    @discardableResult
    public func beScanQrCode(image: UIImage, _ complete: @escaping ([String]) -> Void) -> Self {
        unsafeSend { self._beScanQrCode(image: image, complete) }
        return self
    }
    @discardableResult
    public func beConvertBase64Image(_ complete: @escaping (UIImage) -> Void) -> Self {
        unsafeSend { self._beConvertBase64Image(complete) }
        return self
    }
    @discardableResult
    public func beSubscribeRedux(_ complete: @escaping (SceneState) -> Void) -> Self {
        unsafeSend { self._beSubscribeRedux(complete) }
        return self
    }
    @discardableResult
    public func beUnSubscribe() -> Self {
        unsafeSend(_beUnSubscribe)
        return self
    }

}