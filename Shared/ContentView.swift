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
    @State var activeAdvertiser = false
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
                    destination: iOSAdvertiserView(),
                    isActive: $activeAdvertiser) {
                    Text("")
                }.hidden()
                NavigationLink(
                    destination: iOSAdvertiserView(),
                    isActive: $activeBrowser) {
                    Text("")
                }
            }.onAppear() {
                scenario.beGetRoleOfUser { role in
                    switch role {
                    case "Visitor":
                        self.activeAdvertiser = true
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
