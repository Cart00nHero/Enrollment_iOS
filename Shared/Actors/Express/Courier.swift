//
//  Courier.swift
//  ActorDeveloper
//
//  Created by 林祐正 on 2021/5/6.
//

import Foundation
import Flynn

struct Parcel<T> {
    let contentType: T.Type = T.self
    var sender = ""
    let content: T
}

fileprivate class LogisticsCenter: NSObject {
    static let shared = LogisticsCenter()
    private var warehouse: [String: NSSet] = [:]
    func storeParcel<T>(_ recipient: String,_ parcel: Parcel<T>) {
        let parcelSet: NSMutableSet
        if warehouse[recipient] == nil {
            parcelSet = NSMutableSet()
        } else {
            parcelSet = NSMutableSet(set: warehouse[recipient]!)
        }
        if !parcelSet.contains(parcel) {
            parcelSet.add(parcel)
            warehouse[recipient] = parcelSet
        }
    }
    func collectParcels(_ recipient: Actor) -> NSSet? {
        let key = String(describing: type(of: recipient))
        let parcelSet = warehouse[key] ?? NSSet()
        warehouse.removeValue(forKey: key)
        return parcelSet
    }
    func cancelExpress<T>(_ recipient:String, _ parcel: Parcel<T>) {
        let parcelSet = warehouse[recipient] ?? NSSet()
        let newSet = NSMutableSet.init(set: parcelSet)
        if newSet.contains(parcel) {
            newSet.remove(parcel)
            if newSet.count == 0 {
                warehouse.removeValue(forKey: recipient)
            } else {
                warehouse[recipient] = newSet
            }
        }
    }
}
class Courier: Actor {
    private let center = LogisticsCenter.shared
    private func _beApplyExpress<T>(
        sender: Actor, recipient: String, content: T,
        _ complete:((Parcel<T>) -> Void)?) {
        let senderName = String(describing: type(of: sender))
        let parcel = Parcel(sender: senderName, content: content)
        center.storeParcel(recipient, parcel)
        if complete != nil {
            sender.unsafeSend {
                complete!(parcel)
            }
        }
    }
    private func _beClaim(
        recipient: Actor,_ complete: @escaping (NSSet) -> Void) {
        let parcelSet = center.collectParcels(recipient)
        if parcelSet != nil {
            recipient.unsafeSend {
                complete(parcelSet!)
            }
        }
    }
    private func _beCancel<T>(recipient:String, parcel: Parcel<T>) {
        center.cancelExpress(recipient, parcel)
    }
}

// MARK: - Autogenerated by FlynnLint
// Contents of file after this marker will be overwritten as needed

extension Courier {

    @discardableResult
    public func beApplyExpress<T>(sender: Actor, recipient: String, content: T, _ complete: ((Parcel<T>) -> Void)?) -> Self {
        unsafeSend { self._beApplyExpress(sender: sender, recipient: recipient, content: content, complete) }
        return self
    }
    @discardableResult
    public func beClaim(recipient: Actor, _ complete: @escaping (NSSet) -> Void) -> Self {
        unsafeSend { self._beClaim(recipient: recipient, complete) }
        return self
    }
    @discardableResult
    public func beCancel<T>(recipient: String, parcel: Parcel<T>) -> Self {
        unsafeSend { self._beCancel(recipient: recipient, parcel: parcel) }
        return self
    }

}
