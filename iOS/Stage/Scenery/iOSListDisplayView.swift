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
    var body: some View {
        HStack {
            Text(item.title)
            Text(item.content)
            Spacer()
            Button {
                if !item.content.isEmpty {
                    UIPasteboard.general.string = item.content
                    buttonTitle = "Copied"
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                       // Code you want to be delayed
                        buttonTitle = "Copy"
                    }

                }
            } label: {
                Text(buttonTitle)
            }
            Spacer().frame(width: 20, height: 0, alignment: .center)
        }
    }
}

struct iOSListDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        iOSListDisplayView(index: 0, item: .constant(ListInputItem()))
    }
}
