//
//  WebViewScenario.swift
//  Enrollment (iOS)
//
//  Created by YuCheng on 2021/5/22.
//

import Foundation
import Flynn
import UIKit

class WebViewScenario: Actor {
    private func _beCollectFormUrl(_ complete:@escaping (URL) -> Void) {
        Courier().beClaim(recipient: self) { pSet in
            for parcel in pSet {
                if let parcel = parcel as? Parcel<String> {
                    let formURL = URL(string: parcel.content)
                    formURL?.isReachable(completion: { success in
                        if success {
                            DispatchQueue.main.async {
                                complete(formURL!)
                            }
                        } else {
                            print("不是網址捏")
                        }
                    })
                    return
                }
                if let parcel = parcel as? Parcel<URL> {
                    DispatchQueue.main.async {
                        complete(parcel.content)
                    }
                }
            }
        }
    }
    private func verifyUrl (urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
}

// MARK: - Autogenerated by FlynnLint
// Contents of file after this marker will be overwritten as needed

extension WebViewScenario {

    @discardableResult
    public func beCollectFormUrl(_ complete: @escaping (URL) -> Void) -> Self {
        unsafeSend { self._beCollectFormUrl(complete) }
        return self
    }

}
