//
//  HomeViewModel.swift
//  wtkstockprice
//
//  Created by Chun nan Wang on 2022/9/15.
//

import SwiftUI

//struct Price: Codable,Hashable, Identifiable {
//    var id: UUID
//    var date: String
//    var buy: Double
//    var sell: Double
//    var buyAmount: Int
//    var sellAmount: Int
//    var buyDiff: Double {
//        (sell - buy)
//    }
//    var deal: Double{
//        (buy + sell) / 2
//    }
//
//    var priceUp: Bool = true
//}
class HomeViewModel: ObservableObject {
    //    @Published var price: [Price] = []
//    @Published var prices: [Price] = []
    @Published var ret: [Item] = []
    
    
    
    var service = Service.shared
    init(){
        
    }
    
    
    func load() {

        Task {
            
            try await service.loadData()
            service.parse()
            DispatchQueue.main.async {
                let price = UserDefaults(suiteName: groupIdentifier)?.double(forKey: "lastPrice") ?? 0.0
                
                UIApplication.shared.applicationIconBadgeNumber = lround(Double(price))
            }
            _ = service.checkAlarm()
        } //:Task
        
        
        
    } //: func
    
    func save(){
        print ("leaving homeview")

    }
    
}
