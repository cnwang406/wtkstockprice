//
//  wtkstockpriceApp.swift
//  wtkstockprice
//
//  Created by Chun nan Wang on 2022/9/15.
//

import SwiftUI
import BackgroundTasks
@main
struct wtkstockpriceApp: App {
    
    @Environment(\.scenePhase) private var phase
    @ObservedObject var service = Service.shared
    
    var body: some Scene {
        
        
        WindowGroup {
            ContentView()
        }
        
        // need to .backgroundTask before .OnChange. else compile fail !!!
        .backgroundTask(.appRefresh("refreshData")) {
            print ("\(Date()) BGT qpprefresh on go")
            await scheduleAppRefresh()
            
        }
        .backgroundTask(.urlSession("wtkstockloading")){
            print ("\(Date()) BGT urlsession on go")
        }
        
        
        .onChange(of: phase) { newValue in
            switch newValue{
            case .background:
                print ("backgound")
                scheduleAppRefresh()
                break
            case .active:
                print ("active")
                break
            case .inactive:
                print ("..")
                break
            default:
                print ("...")
                
            }
        }
        

    }
    
    
    func scheduleAppRefresh(){
        let req = BGAppRefreshTaskRequest(identifier: "refreshData")
        req.earliestBeginDate = Date().addingTimeInterval(90)
        print ("\(Date()) scheduleAppRefreshed callback. next is \(req.earliestBeginDate)")
        Task{
            print ("\(Date()) SAR start Task{}")
            try await self.service.loadData()
            print ("\(Date()) SAR start parse()")
            self.service.parse()
            print ("\(Date()) SAR start DispatchQueue")
            DispatchQueue.main.async {
                let price = self.service.price.first?.deal ?? 0.0
                UIApplication.shared.applicationIconBadgeNumber = lround(Double(price) / 2)
            }
            print ("\(Date()) SAR DispatchQueue done")
        }
        do {
            try BGTaskScheduler.shared.submit(req)
            print ("\(Date()) SAR scheduleAppRefreshed regiter again")
        } catch {
            print ("\(Date()) SAR Fail to register BGTaskScheduler")
        }
        print ("\(Date()) SAR scheduleAppRefresh done!")
        scheduleTestNotification()
    }
    func scheduleTestNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Background task has run"
        content.sound = .default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString,
                                            content: content,
                                            trigger: trigger)
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request)
    }
}
