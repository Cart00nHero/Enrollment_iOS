//
//  ContentView.swift
//  Shared
//
//  Created by YuCheng on 2021/5/16.
//

import SwiftUI

struct ContentView: View {
    private let scenario = StartAppScenario()
    @State var activeRoleSelection = false
    @State var activeVisitorUI = false
    @State var activeBrowser = false
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(
                    destination: RoleSelectionView(active: $activeRoleSelection),
                    isActive: $activeRoleSelection) {
                    Text("")
                }.hidden()
                NavigationLink(
                    destination: iOSTabView(),
                    isActive: $activeVisitorUI) {
                    Text("")
                }.hidden()
                NavigationLink(
                    destination: iOSBrowserView(),
                    isActive: $activeBrowser) {
                    Text("")
                }
            }.onAppear() {
                // 頁面切太快會有奇怪的事情發生
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                   // Code you want to be delayed
                    scenario.beGetRoleOfUser { role in
                        switch role {
                        case "Visitor":
                            self.activeVisitorUI = true
                        case "Visited_Unit":
                            self.activeBrowser = true
                        default:
                            self.activeRoleSelection = true
                        }
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
