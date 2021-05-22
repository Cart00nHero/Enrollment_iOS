//
//  TabPageView.swift
//  Enrollment
//
//  Created by YuCheng on 2021/5/22.
//

import SwiftUI

struct TabPageView: View {
    @Binding var pageItems:[TabPageItem]
    var body: some View {
        TabView {
            ForEach(0..<pageItems.count) { i in
                ZStack {
                    pageItems[i].pageView.tag(i)
                }.tabItem({
                    pageItems[i].tabImage
                    Text(pageItems[i].title)
                })
//                .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
            }
        }
//        .tabViewStyle(PageTabViewStyle())
//        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
    }
}
