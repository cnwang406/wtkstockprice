//
//  wtkstockpriceApp.swift
//  wtkstockprice
//
//  Created by Chun nan Wang on 2022/9/15.
//

import SwiftUI

@main
struct wtkstockpriceApp: App {
    
    @Environment(\.scenePhase) private var phase
    @ObservedObject var service = Service.shared
    
    var body: some Scene {
        
        
        WindowGroup {
            ContentView()
        }
        .onChange(of: phase) { newPhase in
            switch newPhase {
//            case .background: scheduleAppRefresh()
            case .active:
                Task{
                    try await service.loadData()
                }
            default: break
            }
        }
    }
}
