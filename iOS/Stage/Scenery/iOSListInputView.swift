//
//  iOSListInputView.swift
//  Enrollment
//
//  Created by YuCheng on 2021/5/21.
//

import SwiftUI

struct iOSListInputView: View {
    let indx: Int
    @Binding var item: AdvertiserItem
    @State private var contentValue = ""
    var body: some View {
        HStack {
            Text(item.title)
            TextField(item.title, text: $contentValue)
        }.onAppear() {
            item.content = self.contentValue
        }
    }
}

struct iOSListInputView_Previews: PreviewProvider {
    static var previews: some View {
        iOSListInputView(indx: 0, item: .constant(AdvertiserItem()))
    }
}
