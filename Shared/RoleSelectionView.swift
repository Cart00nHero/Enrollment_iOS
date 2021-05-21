//
//  RoleSelectionView.swift
//  Enrollment
//
//  Created by YuCheng on 2021/5/21.
//

import SwiftUI

struct RoleSelectionView: View {
    @Binding var active: Bool
    var body: some View {
        VStack {
            Button(action: {}, label: {
                Text("我是訪客")
            })
            Divider().frame(height: 30).hidden()
            Button(action: {}, label: {
                Text("我是店家")
            })
        }
    }
}

struct RoleSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        RoleSelectionView(active: .constant(false))
    }
}
