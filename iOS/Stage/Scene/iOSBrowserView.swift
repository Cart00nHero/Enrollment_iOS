//
//  iOSBrowserView.swift
//  Enrollment (iOS)
//
//  Created by YuCheng on 2021/5/21.
//

import SwiftUI

struct iOSBrowserView: View {
    private let scenario = BrowserScenario()
    @State private var dataSource: [ListInputItem] = []
    @State private var buttonTitle: String = "編輯"
    @State private var toggleSwitchOn = false
    
    var body: some View {
        VStack {
            Spacer().frame(height: 10.0)
            HStack {
                Spacer().frame(width: 10.0)
                Toggle(isOn: $toggleSwitchOn, label: {
                    Text("送表")
                }).onChange(of: toggleSwitchOn) { isOn in
                    if isOn {
                        scenario.beStart()
                    } else {
                        scenario.beStop()
                    }
                }
            }
            Divider().frame(height: 2.0)
            List(dataSource.indexed(), id: \.1.self) { (idx, content) in
                getListView(idx: idx)
            }
            Button(action: {
                scenario.beGetDataSource { source in
                    if buttonTitle == "儲存" {
                        scenario.beSaveUnit()
                        buttonTitle = "編輯"
                    } else {
                        buttonTitle = "儲存"
                    }
                    dataSource = source
                }
            }, label: {
                Text(buttonTitle)
            })
            Spacer()
        }.navigationBarHidden(true)
        .onAppear() {
            scenario.beGetDataSource { source in
                self.dataSource = source
            }
            scenario.beSubscribeRedux { _ in
            }
        }
        .onDisappear() {
            scenario.beUnSubscribeRedux()
        }
    }
    
    // MARK: - private methods
    private func getListView(idx: Int) -> AnyView {
        if buttonTitle == "儲存" {
            let inputView =
                iOSListInputView(index: idx, item: .constant(dataSource[idx]))
            return AnyView(inputView)
        }
        let displayView =
            iOSBrowserListView(index: idx, item: .constant(dataSource[idx]))
        return AnyView(displayView)
    }
    private func spaceValue(_ origin: CGFloat) -> CGFloat {
        return (origin * UIScreen.main.bounds.size.width / 375.0)
    }
}

struct iOSBrowserView_Previews: PreviewProvider {
    static var previews: some View {
        iOSBrowserView()
    }
}
