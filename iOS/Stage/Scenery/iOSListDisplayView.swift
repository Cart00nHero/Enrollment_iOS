//
//  iOSListDisplayView.swift
//  Enrollment (iOS)
//
//  Created by YuCheng on 2021/5/21.
//

import SwiftUI

struct iOSListDisplayView: View {
    let index: Int
    @Binding var item: ListInputItem
    var body: some View {
        HStack {
            Text(item.title)
            Text(item.content)
            Spacer()
            Button {
                
            } label: {
                Text("Copy")
            }
            Spacer().frame(width: 20, height: 0, alignment: .center)
        }
    }
}

struct iOSListDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        iOSListDisplayView(index: 0, item: .constant(ListInputItem()))
    }
}
