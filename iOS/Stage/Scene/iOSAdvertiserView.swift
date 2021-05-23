//
//  iOSAdvertiserView.swift
//  Enrollment (iOS)
//
//  Created by YuCheng on 2021/5/20.
//

import SwiftUI

fileprivate let scenario = AdvertiserScenario()
struct iOSAdvertiserView: View {
    
    @State private var dataSource: [ListInputItem] = []
    @State private var formDatoSource: [ListInputItem] = []
    @State private var buttonTitle: String = "編輯"
    @State private var toggleSwitchOn = false
    @State private var roleBtnTitle = "變換角色"
    
    var body: some View {
        VStack {
            Spacer().frame(height: spaceValue(50.0))
            Divider().frame(height: 10.0)
            List(dataSource.indexed(), id: \.1.self) { (idx, content) in
                getListView(idx: idx)
            }
            Button(action: {
                scenario.beGetDataSource { source in
                    if buttonTitle == "儲存" {
                        scenario.beSaveVisitor()
                        buttonTitle = "編輯"
                    } else {
                        buttonTitle = "儲存"
                    }
                    dataSource = source
                }
            }, label: {
                Text(buttonTitle).foregroundColor(flameScarlet(1.0))
            })
            Spacer().frame(height: 10.0)
            Divider().frame(height: 2.0)
            VStack{
                Spacer().frame(height: 10.0)
                HStack {
                    Spacer().frame(width: 10.0)
                    Toggle(isOn: $toggleSwitchOn, label: {
                        Text("取得店家資訊").foregroundColor(golden(1.0))
                    }).onChange(of: toggleSwitchOn) { isOn in
                        if isOn {
                            scenario.beStart()
                        } else {
                            scenario.beStop()
                        }
                    }.toggleStyle(SwitchToggleStyle(tint: flameScarlet(1.0)))
                    Spacer().frame(width: 10.0)
                }
                List(formDatoSource.indexed(), id: \.1.self) { (idx, content) in
                    iOSListDisplayView(index: idx, item: .constant(content))
                }
                Button(action: {
                    scenario.beChangeRole(enable: true) { _ in
                        roleBtnTitle = "角色已變更"
                    }
                }, label: {
                    Text(roleBtnTitle).foregroundColor(flameScarlet(1.0))
                })
                Spacer()
                Text("角色變更於重新啟動App後選擇")
                    .foregroundColor(skyBlue(1.0))
                    .multilineTextAlignment(.center)
                    .font(.system(size: 14.0))
                Spacer()
            }.frame(height: UIScreen.main.bounds.height/2.5, alignment: .top)
        }.navigationBarHidden(true)
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onAppear() {
            scenario.beGetDataSource { source in
                dataSource = source
            }
            scenario.beSubscribeRedux { newState in
                if let action =
                    newState.currentAction as? ReceivedInitationAction {
                    formDatoSource = action.source
                    toggleSwitchOn = false
                }
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
            iOSListDisplayView(index: idx, item: .constant(dataSource[idx]))
        return AnyView(displayView)
    }
    private func spaceValue(_ origin: CGFloat) -> CGFloat {
        return (origin * UIScreen.main.bounds.size.width / 375.0)
    }
}

struct iOSAdvertiserView_Previews: PreviewProvider {
    static var previews: some View {
        iOSAdvertiserView()
    }
}
