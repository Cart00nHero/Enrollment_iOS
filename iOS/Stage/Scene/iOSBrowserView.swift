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
    @State private var roleBtnTitle = "變更角色"
    
    var body: some View {
        VStack {
            Spacer().frame(height: 60.0)
            HStack {
                Spacer().frame(width: 10.0)
                Toggle(isOn: $toggleSwitchOn, label: {
                    Text("發送表格")
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
                        toggleSwitchOn = true
                    } else {
                        toggleSwitchOn = false
                        buttonTitle = "儲存"
                    }
                    dataSource = source
                }
            }, label: {
                Text(buttonTitle)
            })
            Spacer().frame(height: UIScreen.main.bounds.height/2.0)
            Button(action: {
                scenario.beChangeRole(enable: true) { _ in
                    roleBtnTitle = "角色已變更"
                }
            }, label: {
                Text(roleBtnTitle)
            })
            Spacer()
            Text("該功能於下次App啟動生效").font(Font.system(size: 14.0))
            Spacer()
        }.navigationBarHidden(true)
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onAppear() {
            scenario.beGetDataSource { source in
                self.dataSource = source
            }
            scenario.beSubscribeRedux { _ in
            }
            scenario.beChangeRole(enable: false) { role in
                if role.isEmpty {
                    roleBtnTitle = "角色已變更"
                } else {
                    roleBtnTitle = "變更角色"
                }
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
