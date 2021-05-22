//
//  BrowserScenario.swift
//  Enrollment
//
//  Created by YuCheng on 2021/5/20.
//

import Foundation
import Flynn
import ReSwift
import UIKit
import MultipeerConnectivity

class BrowserScenario: Actor {
    // 登記人
    private var displayName = UIDevice.current.name
    private let serviceType = "visitor-record"
    private var host: PeerHost?
    private var browser: PeerBrowser?
    private var stateChanged: ((SceneState) -> Void)?
    private var invite_list: Set<MCPeerID> = []
    private lazy var visitedUnit = VisitedUnit()
    
    override init() {
        super.init()
        if let storedJson =
            UserDefaults.standard.object(forKey: "visited_unit_info") as? String {
            visitedUnit =
                storedJson.toEntity(to: VisitedUnit.self) ?? VisitedUnit()
        }
        beBrowser()
    }
    private func _beSubscribeRedux(_ complete:@escaping (SceneState) -> Void) {
        stateChanged = complete
        appStore.subscribe(self) {
            $0.select {
                $0.sceneState
            }
        }
    }
    private func _beUnSubscribeRedux() {
        appStore.unsubscribe(self)
        stateChanged = nil
    }
    private func _beBrowser() {
        if !visitedUnit.name.isEmpty {
            displayName = visitedUnit.name
        }
        host = PeerHost(sender: self, peerName: displayName, serviceType: serviceType, encryption: .none)
        browser = PeerBrowser(
            sender: self, peerName: displayName, serviceType: serviceType)
    }
    private func _beStart() {
        browser?.beStartBrowsing()
    }
    private func _beStop() {
        browser?.beStopBrowsing()
    }
    
    private func _beInvite() {
        let json = visitedUnit.toJson()
        let context = json.data(using: .utf8)
        host?.beHostSession(sender: self, { [self] session in
            for peer in invite_list {
                browser?.beInvite(
                    sender: self, peerID: peer,
                    to: session, context: context, timeout: 30, {
                        invite_list.remove(peer)
                })
            }
        })
    }
    
    private func _beGetDataSource(
        _ complete:@escaping ([ListInputItem]) -> Void) {
        let source = [
            ListInputItem(
                title: "代碼：",
                placeholder: "請輸入店家代號",
                keyboardType: .asciiCapable,
                content: visitedUnit.code
            ),
            ListInputItem(
                title: "店家名稱：",
                placeholder: "請輸店家名稱",
                content: visitedUnit.name
            ),
            ListInputItem(
                title: "表格網址：",
                placeholder: "請輸入表格所在網址：",
                keyboardType: .URL,
                content: visitedUnit.cloudForm
            )
        ]
        DispatchQueue.main.async {
            complete(source)
        }
    }
    private func _beStoreUnitInfo(index: Int,value: String) {
        switch index {
        case 0:
            visitedUnit.code = value
        case 1:
            visitedUnit.name = value
        case 2:
            visitedUnit.cloudForm = value
        default: break
        }
    }
    private func _beSaveUnit() {
        let json = visitedUnit.toJson()
        UserDefaults.standard.setValue(json, forKey: "visited_unit_info")
        beBrowser()
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
}
extension BrowserScenario: StoreSubscriber {
    func newState(state: SceneState) {
        switch state.currentAction {
        case let action as ListTextFieldOnChangeAction:
            beStoreUnitInfo(
                index: action.index, value: action.newValue)
        default: break
        }
        if stateChanged != nil {
            DispatchQueue.main.async { [self] in
                stateChanged!(state)
            }
        }
    }
}
extension BrowserScenario: PeerHostProtocol,BrowserProtocol {
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
    // MARK: - BrowserProtocol
    private func _beBrowser(foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        if !invite_list.contains(peerID) {
            invite_list.insert(peerID)
        }
        beInvite()
    }
    
    private func _beBrowser(lostPeer peerID: MCPeerID) {
    }
}

// MARK: - Autogenerated by FlynnLint
// Contents of file after this marker will be overwritten as needed

extension BrowserScenario {

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
    public func beBrowser() -> Self {
        unsafeSend(_beBrowser)
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
    public func beInvite() -> Self {
        unsafeSend(_beInvite)
        return self
    }
    @discardableResult
    public func beGetDataSource(_ complete: @escaping ([ListInputItem]) -> Void) -> Self {
        unsafeSend { self._beGetDataSource(complete) }
        return self
    }
    @discardableResult
    public func beStoreUnitInfo(index: Int, value: String) -> Self {
        unsafeSend { self._beStoreUnitInfo(index: index, value: value) }
        return self
    }
    @discardableResult
    public func beSaveUnit() -> Self {
        unsafeSend(_beSaveUnit)
        return self
    }
    @discardableResult
    public func beChangeRole(enable: Bool, _ complete: @escaping (String) -> Void) -> Self {
        unsafeSend { self._beChangeRole(enable: enable, complete) }
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
    public func beBrowser(foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) -> Self {
        unsafeSend { self._beBrowser(foundPeer: peerID, withDiscoveryInfo: info) }
        return self
    }
    @discardableResult
    public func beBrowser(lostPeer peerID: MCPeerID) -> Self {
        unsafeSend { self._beBrowser(lostPeer: peerID) }
        return self
    }

}
