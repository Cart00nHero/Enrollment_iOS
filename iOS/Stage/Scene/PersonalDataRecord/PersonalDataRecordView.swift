//
//  PersonalDataRecordView.swift
//  Enrollment (iOS)
//
//  Created by YuCheng on 2021/5/16.
//

import SwiftUI

struct PersonalDataRecordView: View {
    @State var dataSource = [""]
    var body: some View {
        VStack {
            List(dataSource.indexed(), id: \.1.self) { idx, content in
                Button(action: {
                }, label: {
                    Text(content)
                })
            }
        }
    }
}

struct PersonalDataRecordView_Previews: PreviewProvider {
    static var previews: some View {
        PersonalDataRecordView()
    }
}
