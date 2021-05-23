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
                .frame(width: 0.0, height: 0.0, alignment: .center)
                NavigationLink(
                    destination: iOSTabView(),
                    isActive: $activeVisitorUI) {
                    Text("")
                }.hidden()
                .frame(width: 0.0, height: 0.0, alignment: .center)
                NavigationLink(
                    destination: iOSBrowserView(),
                    isActive: $activeBrowser) {
                    Text("")
                }.hidden()
                .frame(width: 0.0, height: 0.0, alignment: .center)
                ZStack(alignment: Alignment(horizontal: .center, vertical: .center)) {
                    Image("image_space_surise").resizable().aspectRatio(contentMode: .fill)
                    Text("Even after the darkest nights, morning always comes.")
                        .foregroundColor(Color.white)
                        .font(Font.system(size: 18.0))
                        .multilineTextAlignment(.center)
                }
            }.navigationBarHidden(true)
            .preferredColorScheme(.dark)
            .foregroundColor(.black)
            .onAppear() {
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
