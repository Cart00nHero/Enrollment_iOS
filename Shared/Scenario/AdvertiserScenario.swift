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
    private let serviceType = "visitor-record"
    private var host: PeerHost?
    private var advertiser: PeerAdvertiser?
    private var newStateEvent: ((SceneState) -> Void)?
    private lazy var visitor = VisitorInfo()
    
    override init() {
        super.init()
        if let storedJson = UserDefaults.standard.object(forKey: "visitor_info") as? String {
            visitor = storedJson.toEntity(to: VisitorInfo.self) ?? VisitorInfo()
        }
        beAdvertiser()
    }
    private func _beSubscribeRedux(_ complete:@escaping (SceneState) -> Void) {
        newStateEvent = complete
        appStore.subscribe(self) {
            $0.select {
                $0.sceneState
            }
        }
    }
    private func _beUnSubscribeRedux() {
        appStore.unsubscribe(self)
        newStateEvent = nil
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
                title: "姓名：",
                placeholder: "請輸入您的姓名",
                keyboardType: .namePhonePad,
                content: visitor.name
            ),
            ListInputItem(
                title: "電話：",
                placeholder: "請輸入您的電話",
                keyboardType: .phonePad,
                content: visitor.tel
            ),
            ListInputItem(
                title: "身分證字號：",
                placeholder: "請輸入您的身份證字號",
                keyboardType: .asciiCapable,
                content: visitor.identityNo
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
            visitor.identityNo = value
        default: break
        }
    }
    private func _beSaveVisitor() {
        beStop()
        let json = visitor.toJson()
        UserDefaults.standard.setValue(json, forKey: "visitor_info")
        beAdvertiser()
    }
    func converToFormDatoSources(content: VisitedUnit) -> [ListInputItem] {
        return [
            ListInputItem(
                title: "店家代碼：",
                placeholder: "請輸入店家代號",
                keyboardType: .asciiCapable,
                content: content.code
            ),
            ListInputItem(
                title: "店家名稱：",
                placeholder: "請輸店家名稱",
                content: content.name
            ),
            ListInputItem(
                title: "表格網址：",
                placeholder: "請輸入表格所在網址",
                keyboardType: .URL,
                content: content.cloudForm
            )
        ]
    }
}
extension AdvertiserScenario: StoreSubscriber {
    func newState(state: SceneState) {
        unsafeSend { [self] in
            switch state.currentAction {
            case let action as ListTextFieldOnChangeAction:
                print(action)
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
            let result = converToFormDatoSources(content: unitInfo)
            appStore.dispatch(ReceivedInitationAction(source: result))
        }
    }
}

// MARK: - Autogenerated by FlynnLint
// Contents of file after this marker will be overwritten as needed

extension AdvertiserScenario {

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
