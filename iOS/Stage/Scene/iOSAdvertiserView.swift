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
    @State private var buttonTitle: String = localized("edit")
    @State private var toggleSwitchOn = false
    @State private var roleBtnTitle = localized("switch_role")
    
    var body: some View {
        VStack {
            Spacer().frame(height: autoUISize(50.0))
            Divider().frame(height: 2.0)
            List(dataSource.indexed(), id: \.1.self) { (idx, content) in
                getListView(idx: idx)
            }
            Text(localized("fill_info_description"))
                .font(.system(size: 12.0)).foregroundColor(pistachioGreen(1.0))
            Spacer().frame(height: autoUISize(60.0))
            Button(action: {
                scenario.beGetDataSource { source in
                    if buttonTitle == localized("save") {
                        scenario.beSaveVisitor()
                        buttonTitle = localized("edit")
                    } else {
                        buttonTitle = localized("save")
                    }
                    dataSource = source
                }
            }, label: {
                Text(buttonTitle).foregroundColor(flameScarlet(1.0))
            })
            Spacer().frame(height: autoUISize(10.0))
            Divider().frame(height: 2.0)
            VStack{
                Spacer().frame(height: 10.0)
                HStack {
                    Spacer().frame(width: 10.0)
                    Toggle(isOn: $toggleSwitchOn, label: {
                        Text(localized("get_visited_unit_info"))
                            .foregroundColor(golden(1.0))
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
                    roleBtnTitle = localized("role_changed")
                } else {
                    roleBtnTitle = localized("switch_role")
                }
            }
        }
        .onDisappear() {
            scenario.beUnSubscribeRedux()
            scenario.beStop()
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
            iOSListDisplayView(index: idx, item: .constant(dataSource[idx]))
        return AnyView(displayView)
    }
}

struct iOSAdvertiserView_Previews: PreviewProvider {
    static var previews: some View {
        iOSAdvertiserView()
    }
}
