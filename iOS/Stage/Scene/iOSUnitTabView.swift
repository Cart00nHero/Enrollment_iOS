//
//  iOSUnitTabView.swift
//  Enrollment (iOS)
//
//  Created by YuCheng on 2021/5/27.
//

import SwiftUI

struct iOSUnitTabView: View {
    private let scenario = TabActionScenario()
    @State private var tabIndex = 0
    @State private var pages = [
        TabPageItem(
            pageView: AnyView(iOSBrowserView()),
            tabImage: Image(systemName: "doc.text.magnifyingglass"),
            title: "資料"
        ),
        TabPageItem(
            pageView: AnyView(iOSQRCodeView()),
            tabImage: Image(systemName: "qrcode.viewfinder"),
            title: "QRCode"
        )
    ]
    var body: some View {
        HStack {
            TabPageView(
                items: $pages, tabIdx: $tabIndex)
        }.onAppear() {
            scenario.beSubscribeRedux { newState in
                switch newState.currentAction {
                case is OpenFormURLAction:
                    tabIndex = 1
                default: break
                }
            }
        }
        .onDisappear() {
            scenario.beUnSubscribeRedux()
        }
    }
}

struct iOSUnitTabView_Previews: PreviewProvider {
    static var previews: some View {
        iOSUnitTabView()
    }
}
