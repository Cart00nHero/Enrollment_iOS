//
//  iOSUnitListView.swift
//  Enrollment (iOS)
//
//  Created by YuCheng on 2021/5/22.
//

import SwiftUI

struct iOSUnitListView: View {
    @Binding var dataSource: [ListInputItem]
    var body: some View {
        VStack {
            List(dataSource.indexed(), id: \.1.self) { (idx, content) in
                iOSListDisplayView(index: idx, item: .constant(content))
            }
        }
    }
}

struct iOSUnitListView_Previews: PreviewProvider {
    static var previews: some View {
        iOSUnitListView(dataSource: .constant([]))
    }
}
