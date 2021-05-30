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
    @State private var webUrl: URL = URL(string: "empty")!
    var body: some View {
        VStack {
            getDisplayView()
        }.navigationBarHidden(true)
        .onAppear() {
            scenario.beCollectFormUrl { formURL in
                self.webUrl = formURL
            }
        }
    }
    private func getDisplayView() -> AnyView {
        if webUrl.absoluteString == "empty" {
            return AnyView(
                Text(localized("empty_web_form"))
                    .multilineTextAlignment(.center)
                    .font(.system(size: 24.0))
                    .foregroundColor(golden(1.0))
            )
        } else {
            return AnyView(SwiftUIWebView(url: $webUrl))
        }
    }
}

struct iOSWebView_Previews: PreviewProvider {
    static var previews: some View {
        iOSWebView()
    }
}
