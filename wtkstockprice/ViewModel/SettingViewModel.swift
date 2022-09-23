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
        self.share = UserDefaults(suiteName: groupIdentifier)?.double(forKey: "share") ?? 0.0
        self.priceHigh = UserDefaults(suiteName: groupIdentifier)?.double(forKey: "priceHigh") ?? 150.0
        self.priceLow = UserDefaults(suiteName: groupIdentifier)?.double(forKey: "priceLow") ?? 100.0
    }
    
    func commit(){
        UserDefaults(suiteName: groupIdentifier)?.set(share, forKey: "share")
        UserDefaults(suiteName: groupIdentifier)?.set(priceHigh, forKey: "priceHigh")
        UserDefaults(suiteName: groupIdentifier)?.set(priceLow, forKey: "priceLow")
        UserDefaults(suiteName: groupIdentifier)?.set(notifyMe , forKey: "notifyMe")
    }
}
