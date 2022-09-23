//
//  wtkstockpriceApp.swift
//  wtkstockprice
//
//  Created by Chun nan Wang on 2022/9/15.
//

import SwiftUI
import BackgroundTasks
import WidgetKit
@main
struct wtkstockpriceApp: App {
    
    @Environment(\.scenePhase) private var phase
    @ObservedObject var service = Service.shared
   
    var body: some Scene {
        
        
        WindowGroup {
            ContentView()
        }
        
        .backgroundTask(.appRefresh(backgroundTaskIdentifier)) {Sendable in
            print ("\n====================================\n\(Date()) BGT refreshData on go\n===============================\n")
            //            await register()
            
            await scheduleNotification()
            await handelAppRefresh()
            await scheduleAppRefresh()
            
        }
        
        .onChange(of: phase) { newValue in
            switch newValue{
            case .background:
                print ("backgound")
                Task{
                    await scheduleAppRefresh()
                }

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
    
    
    func scheduleAppRefresh() async{

        let req = BGAppRefreshTaskRequest(identifier: backgroundTaskIdentifier)
        req.earliestBeginDate = Date().addingTimeInterval(30 * 60)  // every 30 min 
        
        do {
            try BGTaskScheduler.shared.submit(req)
            print ("\(Date()) SAR scheduleAppRefreshed regiter again")
            //e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateLaunchForTaskWithIdentifier:@"com.cnwang.wtkstockprice.refreshData"]
        } catch {
            print ("\(Date()) SAR Fail to register BGTaskScheduler")
        }
        
        print ("\(Date()) SAR scheduleAppRefresh done!")
    }
    
    func handelAppRefresh() async{
        print ("\(Date()) into handelAppRefresh)")
        
        Task{
            try? await self.service.loadData()
            self.service.parse()
            UserDefaults(suiteName: groupIdentifier)?.set(self.service.checkAlarm(), forKey: "check")
            
            print ("\(Date()) HAR start DispatchQueue")
            DispatchQueue.main.async {
                let price = UserDefaults(suiteName: groupIdentifier)?.double(forKey: "lastPrice") ?? 0.0
                UIApplication.shared.applicationIconBadgeNumber = lround(Double(price))
                scheduleNotification()
                            }
            print ("\(Date()) HAR DispatchQueue done")
        }
    }
    
    
    func scheduleNotification() {
        print ("STN start")
        let check = UserDefaults(suiteName: groupIdentifier)?.integer(forKey: "check") ?? 3
        let content = UNMutableNotificationContent()
        let price = UserDefaults(suiteName: groupIdentifier)?.double(forKey: "lastPrice") ?? 0.0
        let high = UserDefaults(suiteName: groupIdentifier)?.double(forKey: "priceHigh") ?? 150.0
        let low = UserDefaults(suiteName: groupIdentifier)?.double(forKey: "priceLow") ?? 100.0
        
        
        switch NotifyMeStatus(rawValue: check) {
        case .noData:
            content.title = "無資料"
        case .high:
            content.title = "高於設定價 \(price)>\(high) @\(Date().formatted())"
        case .low:
            content.title = "低於設定價 \(price)<\(low) @\(Date().formatted())"
        case .peace:
            content.title = "最新股價 \(price) @\(Date().formatted())"
        default:
            break
        }
        
        
//        content.title = "聯穎股價 updated \(price) @\(Date().formatted())"
        content.sound = .default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString,
                                            content: content,
                                            trigger: trigger)
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request)
        print ("STN finished")
    }
}
