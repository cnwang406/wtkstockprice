//
//  SettingViewModel.swift
//  wtkstockprice
//
//  Created by Chun nan Wang on 2022/9/15.
//

import SwiftUI

class SettingViewModel: ObservableObject {
    //    @StateObject var vm = SettingViewModel()
    var service = Service.shared
    @Published var stock:String = "聯穎光電"
    @Published var notifyMe:Bool = true
    
    
    @Published var priceHigh: Double
    @Published var priceLow: Double
    
    @Published var share: Double
    
    
    
    
    init(){
        self.share = UserDefaults(suiteName: groupIdentifier)?.double(forKey: "share") ?? 0.0
        self.priceHigh = UserDefaults(suiteName: groupIdentifier)?.double(forKey: "priceHigh") ?? 150.0
        self.priceLow = UserDefaults(suiteName: groupIdentifier)?.double(forKey: "priceLow") ?? 100.0
        if self.priceHigh == self.priceLow {
            self.priceHigh = self.priceLow + 2
        }
        self.stock = UserDefaults(suiteName: groupIdentifier)?.string(forKey: "stock") ?? "聯穎光電"
    }
    
    func commit(){
        UserDefaults(suiteName: groupIdentifier)?.set(share, forKey: "share")
        UserDefaults(suiteName: groupIdentifier)?.set(priceHigh, forKey: "priceHigh")
        UserDefaults(suiteName: groupIdentifier)?.set(priceLow, forKey: "priceLow")
        UserDefaults(suiteName: groupIdentifier)?.set(notifyMe , forKey: "notifyMe")
        if stock != ( UserDefaults(suiteName: groupIdentifier)?.string(forKey: "stock") ?? "" ) {
            UserDefaults(suiteName: groupIdentifier)?.set(stock , forKey: "stock")
            
            Task {
                
                try await service.loadData()
                service.parse()
                DispatchQueue.main.async {
                    let price = UserDefaults(suiteName: groupIdentifier)?.double(forKey: "lastPrice") ?? 0.0
                    
                    UIApplication.shared.applicationIconBadgeNumber = lround(Double(price))
                }
            }
        }
    }
}
