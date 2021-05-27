//
//  ReduxActor.swift
//  Enrollment
//
//  Created by YuCheng on 2021/5/27.
//

import Foundation
import ReSwift

class ReduxActor: StoreSubscriber {
    
    private var newStateEvent: ((SceneState) -> Void)?
    
    func subscribeRedux(subscriber:@escaping(SceneState) -> Void) {
        newStateEvent = subscriber
        appStore.subscribe(self) {
            $0.select {
                $0.sceneState
            }
        }
    }
    func unsubscribe() {
        appStore.unsubscribe(self)
        newStateEvent = nil
    }
    
    deinit {
        unsubscribe()
    }
    
    func newState(state: SceneState) {
        if newStateEvent != nil {
            newStateEvent!(state)
        }
    }
}
