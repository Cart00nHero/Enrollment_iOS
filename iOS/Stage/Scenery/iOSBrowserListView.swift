//
//  iOSBrowserListView.swift
//  Enrollment (iOS)
//
//  Created by YuCheng on 2021/5/22.
//

import SwiftUI

struct iOSBrowserListView: View {
    let index: Int
    @Binding var item: ListInputItem
    var body: some View {
        HStack {
            Text(item.title)
            Text(item.content)
        }
    }
}

struct iOSBrowserListView_Previews: PreviewProvider {
    static var previews: some View {
        iOSBrowserListView(
            index: 0, item: .constant(ListInputItem()))
    }
}