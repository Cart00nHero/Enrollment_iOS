//
//  PeerAdvertiser.swift
//  ActorDeveloper
//
//  Created by YuCheng on 2021/5/20.
//

import Foundation
import Flynn
import MultipeerConnectivity

protocol AdvertiserProtocol {
    @discardableResult
    func beAdvertiser(
        didReceiveInvitationFrom peerID: MCPeerID,
        context: Data?,
        replyInvitation: @escaping (Bool, MCSession?) -> Void) -> Self
}

fileprivate class RoleOfAdvertiser: NSObject {
    
    private var advertiser: MCNearbyServiceAdvertiser!
    var delegate: AdvertiserProtocol?
    
    func actRoleOfAdvertiser(name: String, type:String) {
        /* The serviceType parameter is a short text string used to describe the app's networking protocol. It should be in the same format as a Bonjour service type: up to 15 characters long and valid characters include ASCII lowercase letters, numbers, and the hyphen. A short name that distinguishes itself from unrelated services is recommended; for example, a text chat app made by ABC company could use the service type "abc-txtchat". */
        advertiser = MCNearbyServiceAdvertiser(peer: MCPeerID(displayName: name), discoveryInfo: nil, serviceType: type)
        advertiser.delegate = self
    }
    func startAdvertisingPeer() {
        advertiser.startAdvertisingPeer()
    }
    func stopAdvertisingPeer() {
        advertiser.stopAdvertisingPeer()
    }
    
}

extension RoleOfAdvertiser: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        delegate?.beAdvertiser(didReceiveInvitationFrom: peerID, context: context, replyInvitation: invitationHandler)
    }
    
}

class PeerAdvertiser: Actor {
    
    private let advertiser = RoleOfAdvertiser()
    
    init(sender: AdvertiserProtocol,peerName: String,serviceType:String) {
        advertiser.actRoleOfAdvertiser(name: peerName, type: serviceType)
        advertiser.delegate = sender
    }
    private func _beStartAdvertising() {
        advertiser.startAdvertisingPeer()
    }
    private func _beStopAdvertising() {
        advertiser.stopAdvertisingPeer()
    }
}

// MARK: - Autogenerated by FlynnLint
// Contents of file after this marker will be overwritten as needed

extension PeerAdvertiser {

    @discardableResult
    public func beStartAdvertising() -> Self {
        unsafeSend(_beStartAdvertising)
        return self
    }
    @discardableResult
    public func beStopAdvertising() -> Self {
        unsafeSend(_beStopAdvertising)
        return self
    }

}
