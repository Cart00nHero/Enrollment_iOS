//
//  iOSVisitorTabView.swift
//  Enrollment (iOS)
//
//  Created by YuCheng on 2021/5/27.
//

import SwiftUI

struct iOSVisitorTabView: View {
    private let scenario = TabActionScenario()
    @State private var tabIndex = 0
    @State private var pages = [
        TabPageItem(
            pageView: AnyView(iOSAdvertiserView()),
            tabImage: Image(systemName: "doc.text.magnifyingglass"),
            title: localized("information")
        ),
        TabPageItem(
            pageView: AnyView(iOSWebView()),
            tabImage: Image(systemName: "network"),
            title: localized("web")
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
                case let action as SwitchTabAction:
                    tabIndex = action.tabIndex
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

struct iOSVisitorTabView_Previews: PreviewProvider {
    static var previews: some View {
        iOSVisitorTabView()
    }
}
