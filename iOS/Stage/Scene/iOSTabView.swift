//
//  iOSTabView.swift
//  Enrollment (iOS)
//
//  Created by YuCheng on 2021/5/22.
//

import SwiftUI

struct iOSTabView: View {
    @State private var tabIndex = 0
    @State private var pages = [
        TabPageItem(
            pageView: AnyView(iOSAdvertiserView()),
            tabImage: Image(systemName: "doc.text.magnifyingglass"),
            title: "資料"
        ),
        TabPageItem(
            pageView: AnyView(iOSWebView()),
            tabImage: Image(systemName: "network"),
            title: "網頁"
        )
    ]
    var body: some View {
        HStack {
            TabPageView(
                items: $pages, tabIdx: $tabIndex)
        }
    }
}

struct iOSTabView_Previews: PreviewProvider {
    static var previews: some View {
        iOSTabView()
    }
}
