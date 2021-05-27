//
//  iOSTabView.swift
//  Enrollment (iOS)
//
//  Created by YuCheng on 2021/5/22.
//

import SwiftUI

struct iOSTabView: View {
    private let scenario = TabActionScenario()
    @State private var tabIndex = 0
    @State private var pages:[TabPageItem] = getTabSource()
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

struct iOSTabView_Previews: PreviewProvider {
    static var previews: some View {
        iOSTabView()
    }
}

fileprivate func getTabSource() -> [TabPageItem] {
    guard let role =
            UserDefaults.standard.object(forKey: "role_of_user") as? String
    else { return [] }
    switch role {
    case "visitor_info":
        return [
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
    default:
        return [
            TabPageItem(
                pageView: AnyView(iOSBrowserView()),
                tabImage: Image(systemName: "doc.text.magnifyingglass"),
                title: "資料"
            ),
            TabPageItem(
                pageView: AnyView(iOSQRCodeView()),
                tabImage: Image(systemName: "network"),
                title: "靠杯"
            )
        ]
    }
}
