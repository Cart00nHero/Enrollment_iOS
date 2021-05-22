//
//  iOSWebView.swift
//  Enrollment (iOS)
//
//  Created by YuCheng on 2021/5/22.
//

import SwiftUI
import WebKit

fileprivate let scenario = WebViewScenario()
struct iOSWebView: View {
    @State private var webUrl: URL = URL(string: "https://www.apple.com/")!
    var body: some View {
        VStack {
            SwiftUIWebView(url: $webUrl)
        }.navigationBarHidden(true)
        .onAppear() {
            scenario.beCollectFormUrl { formURL in
                self.webUrl = formURL
            }
        }
    }
}

struct iOSWebView_Previews: PreviewProvider {
    static var previews: some View {
        iOSWebView()
    }
}
