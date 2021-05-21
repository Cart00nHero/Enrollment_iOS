//
//  iOSAdvertiserView.swift
//  Enrollment (iOS)
//
//  Created by YuCheng on 2021/5/20.
//

import SwiftUI

fileprivate let scenario = AdvertiserScenario()
struct iOSAdvertiserView: View {
    @State var dataSource: [AdvertiserItem] = []
    var body: some View {
        VStack {
            List(dataSource.indexed(), id: \.1.self) { (idx, content) in
                iOSListInputView(indx: idx, item: .constant(content))
            }
            Button(action: {
                print("康特:\(dataSource)")
            }, label: {
                Text("編輯")
            })
        }.onAppear() {
//            scenario.beGetDataSource { source in
//                dataSource = source
//            }
        }.navigationBarHidden(true)
    }
}

struct iOSAdvertiserView_Previews: PreviewProvider {
    static var previews: some View {
        iOSAdvertiserView()
    }
}
