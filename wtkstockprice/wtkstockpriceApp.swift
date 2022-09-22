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
        
        .backgroundTask(.appRefresh("com.cnwang.wtkstockprice.refreshData")) {Sendable in
            print ("\n====================================\n\(Date()) BGT refreshData on go\n===============================\n")
            //            await register()
            
            await scheduleTestNotification()
            await handelAppRefresh()
            await scheduleAppRefresh()
            
        }
        
        .onChange(of: phase) { newValue in
            switch newValue{
            case .background:
                print ("backgound")
                Task{
//                    await scheduleTestNotification()
                    await scheduleAppRefresh()
                }
                
//                handelAppRefresh()
                break
            case .active:
                print ("active")
                let t = BGTaskScheduler.shared.getPendingTaskRequests { r in
                    print ("pending task count = \(r.count)")
                    for rr in r {
                        print("prendingTask = \(rr)")
                    }
                }
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
//        await handelAppRefresh()
        let req = BGAppRefreshTaskRequest(identifier: "com.cnwang.wtkstockprice.refreshData")
        
        req.earliestBeginDate = Date().addingTimeInterval(90)
//        req.earliestBeginDate = Calendar.current.date(bySetting: .minute, value: 2, of: Date())
        
        
        print ("\(Date()) scheduleAppRefreshed callback. next is \(req.earliestBeginDate)")
        
        do {
            try BGTaskScheduler.shared.submit(req)
            print ("\(Date()) SAR scheduleAppRefreshed regiter again")
            //e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateLaunchForTaskWithIdentifier:@"com.cnwang.wtkstockprice.refreshData"]
        } catch {
            print ("\(Date()) SAR Fail to register BGTaskScheduler")
        }
        let t = BGTaskScheduler.shared.getPendingTaskRequests { r in
            print ("pending task count = \(r.count)")
            for rr in r {
                print("prendingTask = \(rr)")
            }
//            BGTaskScheduler.shared.cancelAllTaskRequests()
        }
        
        print ("\(Date()) SAR scheduleAppRefresh done!")
        
    }
    
    //    func handelAppRefresh(task: BGAppRefreshTask){
    func handelAppRefresh() async{
        print ("\(Date()) into handelAppRefresh)")
        
//        await self.service.loadInBackgroundTask()
        Task{
            
            try? await self.service.loadData2()
            print ("\(Date()) HAR start Task{}")
            print ("\(Date()) HAR start parse()")
            self.service.parse()
            print ("\(Date()) HAR start DispatchQueue")
            DispatchQueue.main.async {
                let price = self.service.price.first?.deal ?? 0.0
                print ("Got price = \(price)")
                UIApplication.shared.applicationIconBadgeNumber = lround(Double(price))
                scheduleTestNotification()
            }
            print ("\(Date()) HAR DispatchQueue done")
        }
        
        
        
        //        }
        
        
        
        //        scheduleTestNotification()
    }
    
    
    
    
    
    
    func scheduleTestNotification() {
        print ("STN start")
        let content = UNMutableNotificationContent()
        let price = service.price.first?.deal ?? 0.0
        content.title = "background triggered \(price)"
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
