//
//  RoleSelectionView.swift
//  Enrollment
//
//  Created by YuCheng on 2021/5/21.
//

import SwiftUI

fileprivate let scenario = RoleSelectionScenario()
struct RoleSelectionView: View {
    @Binding var active: Bool
    var body: some View {
        VStack {
            Button(action: {
                scenario.beActVisitor {
                    active = false
                }
            }, label: {
                Text("我是訪客")
            })
            Divider().frame(height: 30).hidden()
            Button(action: {
                scenario.beVisitedUnit {
                    active = false
                }
            }, label: {
                Text("我是店家")
            })
        }.navigationBarHidden(true)
    }
}

struct RoleSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        RoleSelectionView(active: .constant(false))
    }
}
