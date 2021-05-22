//
//  TabActionScenario.swift
//  Enrollment
//
//  Created by YuCheng on 2021/5/22.
//

import Foundation
import Flynn
import ReSwift

class TabActionScenario: Actor {
    private var newStateEvent: ((SceneState) -> Void)?
    private func _beSubscribeRedux(
        _ complete:@escaping (SceneState) -> Void) {
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
}
extension TabActionScenario: StoreSubscriber {
    func newState(state: SceneState) {
        unsafeSend { [self] in
            if newStateEvent != nil {
                DispatchQueue.main.async {
                    newStateEvent!(state)
                }
            }
        }
    }
}
