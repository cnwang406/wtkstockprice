//
//  SettingViewModel.swift
//  wtkstockprice
//
//  Created by Chun nan Wang on 2022/9/15.
//

import SwiftUI

class SettingViewModel: ObservableObject {
    @StateObject var vm = SettingViewModel()
    @Published var stock:String = "聯穎光電"
    @Published var notifyMe:Bool = true
    
    
    @Published var priceHigh: Double
    @Published var priceLow: Double
    
    @Published var share: Double
    
    
    
    init(){
        self.share = UserDefaults(suiteName: "group.com.cnwang.wtkstock")?.double(forKey: "share") ?? 0.0
        self.priceHigh = UserDefaults(suiteName: "group.com.cnwang.wtkstock")?.double(forKey: "priceHigh") ?? 150.0
        self.priceLow = UserDefaults(suiteName: "group.com.cnwang.wtkstock")?.double(forKey: "priceLow") ?? 100.0
    }
    
    func commit(){
        UserDefaults(suiteName: "group.com.cnwang.wtkstock")?.set(share, forKey: "share")
        UserDefaults(suiteName: "group.com.cnwang.wtkstock")?.set(priceHigh, forKey: "priceHigh")
        UserDefaults(suiteName: "group.com.cnwang.wtkstock")?.set(priceLow, forKey: "priceLow")
        UserDefaults(suiteName: "group.com.cnwang.wtkstock")?.set(notifyMe , forKey: "notifyMe")
    }
}
