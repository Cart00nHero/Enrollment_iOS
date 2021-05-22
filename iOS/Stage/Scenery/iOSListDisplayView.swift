//
//  iOSListDisplayView.swift
//  Enrollment (iOS)
//
//  Created by YuCheng on 2021/5/21.
//

import SwiftUI

struct iOSListDisplayView: View {
    let index: Int
    @Binding var item: ListInputItem
    @State private var buttonTitle: String = "Copy"
    @State private var contentValue: String = ""
    var body: some View {
        HStack {
            Text(item.title)
            Text(contentValue)
            Spacer()
            Button {
                if buttonTitle == "Copy" && !item.content.isEmpty {
                    UIPasteboard.general.string = item.content
                    buttonTitle = "Copied"
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                       // Code you want to be delayed
                        buttonTitle = "Copy"
                    }
                } else {
                    appStore.dispatch(OpenFormURLAction(urlString: item.content))
                }
            } label: {
                Text(buttonTitle)
            }
            Spacer().frame(width: 20, height: 0, alignment: .center)
        }.onAppear() {
            getItemContent(item)
        }
    }
    private func getItemContent(_ item: ListInputItem) {
        if item.title.contains("表格網址：") {
            buttonTitle = "Go"
            contentValue = "點擊Go前往網頁"
        } else {
            contentValue = item.content
        }
    }
}
struct iOSListDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        iOSListDisplayView(index: 0, item: .constant(ListInputItem()))
    }
}
