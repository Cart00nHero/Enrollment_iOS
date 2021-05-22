//
//  TabPageView.swift
//  Enrollment
//
//  Created by YuCheng on 2021/5/22.
//

import SwiftUI

struct TabPageView: View {
    @Binding var items:[TabPageItem]
    @Binding var tabIdx: Int
    var body: some View {
        TabView(selection: $tabIdx) {
            ForEach(0..<items.count) { i in
                ZStack {
                    items[i].pageView.tag(i)
                }.tabItem({
                    items[i].tabImage
                    Text(items[i].title)
                })
                .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
            }
        }
//        .tabViewStyle(PageTabViewStyle())
//        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
    }
}
