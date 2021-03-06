//
//  AdvertiserScenario.swift
//  Enrollment
//
//  Created by YuCheng on 2021/5/20.
//

import Foundation
import Flynn
import ReSwift
import UIKit
import MultipeerConnectivity

class AdvertiserScenario: Actor {
    // 訪客
    private var displayName = UIDevice.current.name
    private var host: PeerHost?
    private var advertiser: PeerAdvertiser?
    private var newStateEvent: ((SceneState) -> Void)?
    private lazy var visitor = VisitorInfo()
    private let redux = ReduxActor()
    
    override init() {
        super.init()
        if let storedJson =
            UserDefaults.standard.object(forKey: "visitor_info") as? String {
            visitor =
                storedJson.toEntity(to: VisitorInfo.self) ?? VisitorInfo()
        }
        beAdvertiser()
    }
    private func _beAdvertiser() {
        if !visitor.name.isEmpty {
            displayName = visitor.name
        }
        host = PeerHost(sender: self, peerName: displayName, serviceType: serviceType, encryption: .none)
        advertiser = PeerAdvertiser(sender: self, peerName: displayName, serviceType: serviceType)
    }
    private func _beStart() {
        advertiser?.beStartAdvertising()
    }
    private func _beStop() {
        advertiser?.beStopAdvertising()
    }
    private func _beGetDataSource(
        _ complete:@escaping ([ListInputItem]) -> Void) {
        let source = [
            ListInputItem(
                title: "\(localized("name"))：",
                placeholder: localized("please_input_your_name"),
                keyboardType: .namePhonePad,
                content: visitor.name
            ),
            ListInputItem(
                title: "\(localized("tel"))：",
                placeholder: localized("please_enter_your_phone_number"),
                keyboardType: .phonePad,
                content: visitor.tel
            ),
            ListInputItem(
                title: "\(localized("other_info"))：",
                placeholder: localized("please_fill_in_what_you_want_to_pre-fill"),
                content: visitor.others
            )
        ]
        DispatchQueue.main.async {
            complete(source)
        }
    }
    private func _beStoreVisitorInfo(index: Int,value: String) {
        switch index {
        case 0:
            visitor.name = value
        case 1:
            visitor.tel = value
        case 2:
            visitor.others = value
        default: break
        }
    }
    private func _beSaveVisitor() {
        beStop()
        let json = visitor.toJson()
        UserDefaults.standard.setValue(json, forKey: "visitor_info")
        beAdvertiser()
    }
    private func _beChangeRole(
        enable: Bool,_ complete:@escaping (String) -> Void) {
        if enable {
            UserDefaults.standard.removeObject(forKey: "role_of_user")
            DispatchQueue.main.async {
                complete("")
            }
        } else {
            if let role =
                UserDefaults.standard.object(forKey: "role_of_user") as? String {
                DispatchQueue.main.async {
                    complete(role)
                }
            } else {
                DispatchQueue.main.async {
                    complete("")
                }
            }
        }
        
    }
    private func _beSubscribeRedux(_ complete:@escaping (SceneState) -> Void) {
        newStateEvent = complete
        redux.subscribeRedux { [self] state in
            unsafeSend {
                switch state.currentAction {
                case let action as ListTextFieldOnChangeAction:
                    beStoreVisitorInfo(
                        index: action.index, value: action.newValue)
                default: break
                }
                if newStateEvent != nil {
                    DispatchQueue.main.async {
                        newStateEvent!(state)
                    }
                }
            }
        }
    }
    private func _beUnSubscribeRedux() {
        redux.unsubscribe()
        newStateEvent = nil
    }
    // MARK: - private
    private func converToFormDatoSources(content: VisitedUnit) -> [ListInputItem] {
        return [
            ListInputItem(
                title: "\(localized("place_code"))：",
                placeholder: localized("please_input_place_code"),
                keyboardType: .asciiCapable,
                content: content.code
            ),
            ListInputItem(
                title: "\(localized("name"))：",
                placeholder: localized("please_input_unit_name"),
                content: content.name
            ),
            ListInputItem(
                title: "\(localized("form_url"))：",
                placeholder: localized("please_input_form_url"),
                keyboardType: .URL,
                content: content.cloudForm
            )
        ]
    }
}

extension AdvertiserScenario: PeerHostProtocol, AdvertiserProtocol {
    // MARK: - PeerHostProtocol
    private func _beSession(peer peerID: MCPeerID, didChange state: MCSessionState) {
    }
    private func _beSession(didReceive data: Data, fromPeer peerID: MCPeerID) {
    }
    
    private func _beSession(didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }
    
    private func _beSession(didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    }
    
    private func _beSession(didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    }
    // MARK: - AdvertiserProtocol
    private func _beAdvertiser(
        didReceiveInvitationFrom peerID: MCPeerID,
        context: Data?, replyInvitation: @escaping (Bool, MCSession?) -> Void) {
        if context != nil {
            let json = String(data: context!, encoding: .utf8)
            guard let unitInfo: VisitedUnit = json?.toEntity(to: VisitedUnit.self) else { return }
            if !unitInfo.qrB64Image.isEmpty {
                Courier().beApplyExpress(
                    sender: self, recipient: "QRCodeScenario", content: unitInfo, nil)
            }
            let result = converToFormDatoSources(content: unitInfo)
            appStore.dispatch(ReceivedInitationAction(source: result))
        }
    }
}

// MARK: - Autogenerated by FlynnLint
// Contents of file after this marker will be overwritten as needed

extension AdvertiserScenario {

    @discardableResult
    public func beAdvertiser() -> Self {
        unsafeSend(_beAdvertiser)
        return self
    }
    @discardableResult
    public func beStart() -> Self {
        unsafeSend(_beStart)
        return self
    }
    @discardableResult
    public func beStop() -> Self {
        unsafeSend(_beStop)
        return self
    }
    @discardableResult
    public func beGetDataSource(_ complete: @escaping ([ListInputItem]) -> Void) -> Self {
        unsafeSend { self._beGetDataSource(complete) }
        return self
    }
    @discardableResult
    public func beStoreVisitorInfo(index: Int, value: String) -> Self {
        unsafeSend { self._beStoreVisitorInfo(index: index, value: value) }
        return self
    }
    @discardableResult
    public func beSaveVisitor() -> Self {
        unsafeSend(_beSaveVisitor)
        return self
    }
    @discardableResult
    public func beChangeRole(enable: Bool, _ complete: @escaping (String) -> Void) -> Self {
        unsafeSend { self._beChangeRole(enable: enable, complete) }
        return self
    }
    @discardableResult
    public func beSubscribeRedux(_ complete: @escaping (SceneState) -> Void) -> Self {
        unsafeSend { self._beSubscribeRedux(complete) }
        return self
    }
    @discardableResult
    public func beUnSubscribeRedux() -> Self {
        unsafeSend(_beUnSubscribeRedux)
        return self
    }
    @discardableResult
    public func beSession(peer peerID: MCPeerID, didChange state: MCSessionState) -> Self {
        unsafeSend { self._beSession(peer: peerID, didChange: state) }
        return self
    }
    @discardableResult
    public func beSession(didReceive data: Data, fromPeer peerID: MCPeerID) -> Self {
        unsafeSend { self._beSession(didReceive: data, fromPeer: peerID) }
        return self
    }
    @discardableResult
    public func beSession(didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) -> Self {
        unsafeSend { self._beSession(didReceive: stream, withName: streamName, fromPeer: peerID) }
        return self
    }
    @discardableResult
    public func beSession(didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) -> Self {
        unsafeSend { self._beSession(didStartReceivingResourceWithName: resourceName, fromPeer: peerID, with: progress) }
        return self
    }
    @discardableResult
    public func beSession(didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) -> Self {
        unsafeSend { self._beSession(didFinishReceivingResourceWithName: resourceName, fromPeer: peerID, at: localURL, withError: error) }
        return self
    }
    @discardableResult
    public func beAdvertiser(didReceiveInvitationFrom peerID: MCPeerID, context: Data?, replyInvitation: @escaping (Bool, MCSession?) -> Void) -> Self {
        unsafeSend { self._beAdvertiser(didReceiveInvitationFrom: peerID, context: context, replyInvitation: replyInvitation) }
        return self
    }

}
