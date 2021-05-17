//
//  Musician.swift
//  iListenOnWatch Extension
//
//  Created by 林祐正 on 2021/4/19.
//  Copyright © 2021 SmartFun. All rights reserved.
//

import Foundation
import Flynn
import AVFoundation
import AVKit

enum TrackStatus {
    case Stop,Play,Pause
}

class Musician: Actor {
    private struct PlayStateBinder {
        let sender: Actor
        let changedEvent: ((TrackStatus) -> Void)
    }
    private struct TrackEndBinder {
        let sender: Actor
        let didEndEvent: (() -> Void)
    }
    private struct DurationBinder {
        let sender: Actor
        let durationTime: ((Float64) -> Void)
    }
    // MARK: - Params
    static let shared : Musician = Musician()
    private var conductor: AVPlayer?
    private var playStateBinder: PlayStateBinder?
    private var trackEndBinder: TrackEndBinder?
    private var durationBinder: DurationBinder?
    private var timeObserverToken: Any?
    private var currentVolume: Float = 0.2
    private var resumeTime = CMTime.zero
    private var playStatus: TrackStatus = .Stop {
        didSet {
            playStateBinder?.sender.unsafeSend { [self] in
                playStateBinder?.changedEvent(playStatus)
            }
        }
    }
    override init() {
        super.init()
//        setAudioSessionCategory()
        beRequestRoute()
    }
    
    private func _bePrepareConcert(trackUrl: String) {
        if conductor == nil {
            conductorInPlace(trackUrl)
        } else {
            changeTrack(newUrl: trackUrl)
        }
    }
    
    private func _bePlay() {
        if playStatus != .Play {
            playStatus = .Play
            setAudioSessionCategory()
            addPeriodicTimeObserver()
            conductor?.seek(to: resumeTime)
            conductor?.play()
        }
    }
    private func _beResume(resumeAt sec: Int) {
        resumeTime = CMTimeMakeWithSeconds(Float64(sec), preferredTimescale: 1)
        bePlay()
    }
    private func _bePause() {
        if playStatus == .Play {
            playStatus = .Pause
            conductor?.pause()
        }
    }
    private func _beStop() {
        playStatus = .Stop
        conductor?.pause()
        resumeTime = CMTime.zero
        conductor?.seek(to: resumeTime)
        removePeriodicTimeObserver()
    }
    private func _beEndConcert() {
        beStop()
        conductor = nil
    }
    
    private func _beBindPlayState(
        sender: Actor,_ complete:@escaping (TrackStatus) -> Void) {
        playStateBinder = PlayStateBinder(sender: sender, changedEvent: complete)
    }
    
    private func _beBindDuration(
        sender: Actor,
        _ complete: @escaping (Float64) -> Void) {
        durationBinder =
            DurationBinder(sender: sender, durationTime: complete)
    }
    
    private func _beUpdateVolume(_ volume: Float) {
        conductor?.volume = volume
    }
    
    private func _beBindTrackDidEndEvent(
        sender: Actor,_ complete:@escaping () -> Void) {
        trackEndBinder =
            TrackEndBinder(sender: sender, didEndEvent: complete)
    }
    /*  Only For Watch  */
    
    private func _beRequestRoute() {
        
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setActive(false, options: .notifyOthersOnDeactivation)
            try session.setCategory(AVAudioSession.Category.playback,
                                    mode: .default,
                                    policy: .longFormAudio,
                                    options: [])
        } catch let error {
            fatalError("*** Unable to set up the audio session: \(error.localizedDescription) ***")
        }
        // Activate and request the route.
        session.activate(options: []) { (success, error) in
            guard error == nil else {
                print("*** An error occurred: \(error!.localizedDescription) ***")
                // Handle the error here.
                return
            }
        }
    }
    // MARK: - private
    private func setAudioSessionCategory() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    private func changeTrack(newUrl: String) {
        let trackItem = AVPlayerItem(url: URL(string: newUrl)!)
        conductor?.replaceCurrentItem(with: trackItem)
        addTrackDidEndObserver(item: trackItem)
    }
    private func conductorInPlace(_ trackUrl: String) {
        if trackUrl.isEmpty {
            conductor = AVPlayer()
        } else {
            let defaultItem = AVPlayerItem(url: URL(string: trackUrl)!)
            conductor = AVPlayer(playerItem: defaultItem)
            addTrackDidEndObserver(item: defaultItem)
        }
        currentVolume = conductor?.volume ?? 0.5
    }
    private func addPeriodicTimeObserver() {
        if timeObserverToken == nil {
            // Notify every half second
            let timeScale = CMTimeScale(NSEC_PER_SEC)
            let time = CMTime(seconds: 1.0, preferredTimescale: timeScale)
            timeObserverToken = conductor?.addPeriodicTimeObserver(
                forInterval: time,queue: .main) { [self] time in
                resumeTime = time
                durationBinder?.sender.unsafeSend {
                    durationBinder?.durationTime(CMTimeGetSeconds(time))
                }
            }
        }
    }
    
    private func removePeriodicTimeObserver() {
        if let timeObserverToken = timeObserverToken {
            conductor?.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
    }
    private func addTrackDidEndObserver(item: AVPlayerItem) {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(
            self, selector: #selector(trackDidEnd(note:)),
            name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: item)
    }
    @objc private func trackDidEnd(note: NSNotification) {
        trackEndBinder?.sender.unsafeSend { [self] in
            trackEndBinder?.didEndEvent()
        }
    }

}

// MARK: - Autogenerated by FlynnLint
// Contents of file after this marker will be overwritten as needed

extension Musician {

    @discardableResult
    public func bePrepareConcert(trackUrl: String) -> Self {
        unsafeSend { self._bePrepareConcert(trackUrl: trackUrl) }
        return self
    }
    @discardableResult
    public func bePlay() -> Self {
        unsafeSend(_bePlay)
        return self
    }
    @discardableResult
    public func beResume(resumeAt sec: Int) -> Self {
        unsafeSend { self._beResume(resumeAt: sec) }
        return self
    }
    @discardableResult
    public func bePause() -> Self {
        unsafeSend(_bePause)
        return self
    }
    @discardableResult
    public func beStop() -> Self {
        unsafeSend(_beStop)
        return self
    }
    @discardableResult
    public func beEndConcert() -> Self {
        unsafeSend(_beEndConcert)
        return self
    }
    @discardableResult
    public func beBindPlayState(sender: Actor, _ complete: @escaping (TrackStatus) -> Void) -> Self {
        unsafeSend { self._beBindPlayState(sender: sender, complete) }
        return self
    }
    @discardableResult
    public func beBindDuration(sender: Actor, _ complete: @escaping (Float64) -> Void) -> Self {
        unsafeSend { self._beBindDuration(sender: sender, complete) }
        return self
    }
    @discardableResult
    public func beUpdateVolume(_ volume: Float) -> Self {
        unsafeSend { self._beUpdateVolume(volume) }
        return self
    }
    @discardableResult
    public func beBindTrackDidEndEvent(sender: Actor, _ complete: @escaping () -> Void) -> Self {
        unsafeSend { self._beBindTrackDidEndEvent(sender: sender, complete) }
        return self
    }
    @discardableResult
    public func beRequestRoute() -> Self {
        unsafeSend(_beRequestRoute)
        return self
    }

}
