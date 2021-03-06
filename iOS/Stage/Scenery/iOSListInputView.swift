//
//  iOSListInputView.swift
//  Enrollment
//
//  Created by YuCheng on 2021/5/21.
//

import SwiftUI

struct iOSListInputView: View {
    let index: Int
    @Binding var item: ListInputItem
    @State private var contentValue = ""
    @State private var fontSize:CGFloat = 16.0
    var body: some View {
        HStack {
            Text(item.title)
                .font(.system(size: fontSize))
                .foregroundColor(golden(1.0))
            TextField(item.placeholder, text: $contentValue)
                .font(.system(size: fontSize))
                .modifier(TextFieldClearButton(text: $contentValue))
                .keyboardType(item.keyboardType)
                .onChange(of: contentValue) { newValue in
                appStore.dispatch(
                    ListTextFieldOnChangeAction(index: index, newValue: newValue))
            }
        }.onAppear() {
            self.contentValue = item.content
        }
    }
}

struct iOSListInputView_Previews: PreviewProvider {
    static var previews: some View {
        iOSListInputView(index: 0, item: .constant(ListInputItem()))
    }
}
