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
    @State private var textColor: Color = flameScarlet(1.0)
    @State private var fontSize:CGFloat = 14.0
    var body: some View {
        HStack {
            Text(item.title)
                .font(.system(size: fontSize))
                .foregroundColor(golden(1.0))
            Text(contentValue)
                .font(.system(size: fontSize))
                .foregroundColor(golden(1.0))
            Spacer()
            Button {
                if item.title.contains(localized("form_url")) {
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
                Text(buttonTitle)
                    .font(.system(size: fontSize))
                    .foregroundColor(textColor)
            }
            Spacer().frame(width: 20, height: 0, alignment: .center)
        }.onAppear() {
            getItemContent(item)
        }
    }
    private func getItemContent(_ item: ListInputItem) {
        if item.title.contains(localized("form_url")) {
            buttonTitle = "Go"
            contentValue = localized("go_to_fill_in")
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
