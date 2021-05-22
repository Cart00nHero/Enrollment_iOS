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
    @State private var textColor: Color = Color.blue
    var body: some View {
        HStack {
            Text(item.title)
            Text(contentValue)
            Spacer()
            Button {
                if item.title.contains("表格網址：") {
                    appStore.dispatch(
                        OpenFormURLAction(urlString: item.content))
                } else {
                    if !item.content.isEmpty {
                        UIPasteboard.general.string = item.content
                        buttonTitle = "Copied"
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            // Code you want to be delayed
                            buttonTitle = "Copy"
                        }
                    }
                }
            } label: {
                Text(buttonTitle).foregroundColor(textColor)
            }
            Spacer().frame(width: 20, height: 0, alignment: .center)
        }.onAppear() {
            getItemContent(item)
        }
    }
    private func getItemContent(_ item: ListInputItem) {
        if item.title.contains("表格網址：") {
            buttonTitle = "Go"
            contentValue = "點擊Go前往填寫"
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
