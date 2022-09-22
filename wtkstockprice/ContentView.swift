//
//  ContentView.swift
//  wtkstockprice
//
//  Created by Chun nan Wang on 2022/9/15.
//

import SwiftUI
@MainActor
struct ContentView: View {
    @State var selection: Int = 0
    var body: some View {
        VStack{
            
            TabView(selection: $selection) {
                
                HomeView().tabItem {
                    NavigationLink(destination: HomeView()) {
                        
                        Image(systemName: "chart.xyaxis.line")
                        Text("Price")
                    }
                    
                }
                
                SettingView().tabItem {
                    NavigationLink(destination: SettingView()) {
                        Image(systemName: "gear.circle")
                        Text("setting")
                    }
                }
                
            }
        }
        .onAppear{
            Task{
                try await Service.shared.loadData()
                try await Service.shared.parse()
                try await Service.shared.checkAlarm()
                
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
