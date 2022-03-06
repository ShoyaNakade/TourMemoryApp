//
//  ContentView.swift
//  TourMemoryApp
//
//  Created by 中出翔也 on 2022/01/05.
//

import SwiftUI
import MapUI
import NoteUI
import Data
import DestinationUI
import Model
import ComposeUI


struct ContentView: View {
    //MARK: - PROPERTY
    private enum Tabs: String {
        case map = "思い出マップ"
        case note = "日記リスト"
        case destination = "行きたいリスト"
    }
    @State var isLogin = true
    @State private var isLoading = true
    
    @EnvironmentObject var myMemory : MyMemory
    @State private var selectedTab: Tabs = .map
    //    @State private var navigationTitle: String = Tabs.map.rawValue
    
    public init() {
        UITabBar.appearance().backgroundColor = UIColor(Color("TabBack"))
        // 選択していないアイテム色を指定
        //        UITabBar.appearance().unselectedItemTintColor = UIColor.green
    }
    
    //MARK: - BODY
    var body: some View {
        //        NavigationView
        ZStack {
            VStack {
                TabView(selection: $selectedTab) {
                    TourMapView()
                        .tabItem {
                            Label("マップ", systemImage: "map")
                        }
                        .tag(Tabs.map)
                    //                    .environmentObject(myMemory)
                    
                    TourNoteView()
                        .tabItem {
                            Label("日記", systemImage: "note")
                        }
                        .tag(Tabs.note)
                    //                    .environmentObject(myMemory)
                    TourDestinationView()
                        .tabItem {
                            Label("行きたい", systemImage: "scalemass")
                        }
                        .tag(Tabs.destination)
                    //                    .environmentObject(myMemory)
                }
                .accentColor(.primary)
                .sheet(isPresented:  $myMemory.isLogin) {
                    AuthUIView()
                }
                AdMobView()
                    .frame(height: 50)
            }
            
            if myMemory.isLoading {
                HUDProgressView(placeHolder: "データ更新中...\n(30秒程度かかる場合があります)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        //            .environmentObject(myMemory)
    }
}
