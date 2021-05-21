//
//  ContentView.swift
//  Shared
//
//  Created by YuCheng on 2021/5/16.
//

import SwiftUI

struct ContentView: View {
    @State var activeAdvertiserView = false
    var body: some View {
        VStack {
        }
//        List(dataSource.indexed(), id: \.1.self) { idx, content in
//            Button(action: {
//                switch content {
//                case "熱門推薦":
//                    scenario.beSendMessage(message: ["toApp_GetTagAlbums" : "hot"], nil)
//                case "關注專輯":
//                    scenario.beSendMessage(message: ["toApp_GetLikeAlbums" : ""], nil)
//                case "收藏單集":
//                    scenario.beSendMessage(message: ["toApp_GetLikeTracks" : ""], nil)
//                    activeLikeTracks = true
//                default: break
//                }
//            }, label: {
//                Text(content)
//            })
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
