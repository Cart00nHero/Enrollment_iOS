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
    @State private var buttonTitle: String = NSLocalizedString("edit", comment: "編輯")
    @State private var toggleSwitchOn = false
    @State private var roleBtnTitle =
        NSLocalizedString("switch_role", comment: "變換角色")
    
    var body: some View {
        VStack {
            Spacer().frame(height: autoUISize(100.0))
            HStack {
                Spacer().frame(width: 10.0)
                Toggle(isOn: $toggleSwitchOn, label: {
                    Text(localized("send_info")).foregroundColor(golden(1.0))
                }).onChange(of: toggleSwitchOn) { isOn in
                    if isOn {
                        scenario.beStart()
                    } else {
                        scenario.beStop()
                    }
                }.toggleStyle(SwitchToggleStyle(tint: flameScarlet(1.0)))
                Spacer().frame(width: 10.0)
            }
            Divider().frame(height: 2.0)
            List(dataSource.indexed(), id: \.1.self) { (idx, content) in
                getListView(idx: idx)
            }
            Button(action: {
                scenario.beGetDataSource { source in
                    if buttonTitle == localized("save") {
                        scenario.beSaveUnit()
                        buttonTitle = localized("edit")
                        toggleSwitchOn = true
                    } else {
                        toggleSwitchOn = false
                        buttonTitle = localized("save")
                    }
                    dataSource = source
                }
            }, label: {
                Text(buttonTitle).foregroundColor(flameScarlet(1.0))
            })
            Spacer().frame(height: UIScreen.main.bounds.height/3.0)
            Button(action: {
                scenario.beChangeRole(enable: true) { _ in
                    roleBtnTitle = localized("role_changed")
                }
            }, label: {
                Text(roleBtnTitle).foregroundColor(flameScarlet(1.0))
            })
            Spacer()
            Text(localized("role_changed_description"))
                .foregroundColor(pistachioGreen(1.0))
                .multilineTextAlignment(.center)
                .font(.system(size: 14.0))
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
                    roleBtnTitle = localized("role_changed")
                } else {
                    roleBtnTitle = localized("switch_role")
                }
            }
        }
        .onDisappear() {
            toggleSwitchOn = false
        }
    }
    
    // MARK: - private methods
    private func getListView(idx: Int) -> AnyView {
        if buttonTitle == localized("save") {
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
