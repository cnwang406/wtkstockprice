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
    
    
    @Published var priceHigh:Double = 300.0
    @Published var priceLow: Double=100.0
    
    init(){
        
    }
}
