//
//  PeerBrowser.swift
//  ActorDeveloper
//
//  Created by YuCheng on 2021/5/20.
//

import Foundation
import Flynn
import MultipeerConnectivity

protocol BrowserProtocol {
    @discardableResult
    func beBrowser(foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) -> Self
    @discardableResult
    func beBrowser(lostPeer peerID: MCPeerID) -> Self
}
fileprivate class RoleOfBrowser: NSObject {
    
    private var browser: MCNearbyServiceBrowser!
    var delegate: BrowserProtocol?
    
    func actRoleOfBrowser(name: String,type:String) {
        browser = MCNearbyServiceBrowser(peer: MCPeerID(displayName: name), serviceType: type)
        browser.delegate = self
    }
    func startBrowsingForPeers() {
        browser.startBrowsingForPeers()
    }
    func stopBrowsingForPeers() {
        browser.stopBrowsingForPeers()
    }
    func invitePeer(_ peerID: MCPeerID, _ session: MCSession, _ context: Data?, _ timeout: TimeInterval) {
        browser.invitePeer(peerID, to: session, withContext: context, timeout: timeout)
    }
}

extension RoleOfBrowser: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        delegate?.beBrowser(foundPeer: peerID, withDiscoveryInfo: info)
    }
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        delegate?.beBrowser(lostPeer: peerID)
    }
}
class PeerBrowser: Actor {
    
    private let browser = RoleOfBrowser()
    
    init(sender: BrowserProtocol,peerName: String,serviceType:String) {
        browser.actRoleOfBrowser(name: peerName, type: serviceType)
        browser.delegate = sender
    }
    private func _beStartBrowsing() {
        browser.startBrowsingForPeers()
    }
    private func _beStopBrowsing() {
        browser.stopBrowsingForPeers()
    }
    
    private func _beInvite(
        sender: Actor, peerID: MCPeerID, to session: MCSession,
        context: Data?, timeout: TimeInterval,
        _ complete:(() -> Void)?) {
        browser.invitePeer(peerID, session, context, timeout)
        if complete != nil {
            sender.unsafeSend {
                complete!()
            }
        }
    }
}

// MARK: - Autogenerated by FlynnLint
// Contents of file after this marker will be overwritten as needed

extension PeerBrowser {

    @discardableResult
    public func beStartBrowsing() -> Self {
        unsafeSend(_beStartBrowsing)
        return self
    }
    @discardableResult
    public func beStopBrowsing() -> Self {
        unsafeSend(_beStopBrowsing)
        return self
    }
    @discardableResult
    public func beInvite(sender: Actor, peerID: MCPeerID, to session: MCSession, context: Data?, timeout: TimeInterval, _ complete: (() -> Void)?) -> Self {
        unsafeSend { self._beInvite(sender: sender, peerID: peerID, to: session, context: context, timeout: timeout, complete) }
        return self
    }

}
