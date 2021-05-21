//
//  iOSAdvertiserView.swift
//  Enrollment (iOS)
//
//  Created by YuCheng on 2021/5/20.
//

import SwiftUI

fileprivate let scenario = AdvertiserScenario()
struct iOSAdvertiserView: View {
    
    @State var dataSource: [ListInputItem] = []
    @State var buttonTitle: String = "編輯"
    @State var toggleSwitchOn = false
    
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
                Text(buttonTitle)
            })
            Spacer().frame(height: 10.0)
            Divider().frame(height: 2.0)
            VStack{
                Spacer().frame(height: 10.0)
                HStack {
                    Spacer().frame(width: 10.0)
                    Toggle(isOn: $toggleSwitchOn, label: {
                        Text("領表涕泣")
                    }).onChange(of: toggleSwitchOn) { isOn in
                        if isOn {
                            scenario.beStartAdvertising()
                        } else {
                            scenario.beStopAdvertising()
                        }
                    }
                }
            }.frame(height: UIScreen.main.bounds.height/2.0, alignment: .top)
            .ignoresSafeArea(.keyboard)
        }.navigationBarHidden(true)
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onAppear() {
            scenario.beGetDataSource { source in
                dataSource = source
            }
            scenario.beSubscribeRedux { newState in
                switch newState.currentAction {
                case let action as ListTextFieldOnChangeAction:
                    scenario.beStoreVisitorInfo(
                        index: action.index, value: action.newText)
                default: break
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
