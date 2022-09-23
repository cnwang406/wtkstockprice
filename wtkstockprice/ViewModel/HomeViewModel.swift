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
//        do{
//            if let data = UserDefaults(suiteName: "group.com.cnwang.wtkstock")?.data(forKey: "prices") {
//                self.prices = try JSONDecoder().decode([Price].self, from: data)
//            }
//        } catch {
//            self.prices = []
//        }
        
        Task {
            
            try await service.loadData()
            service.parse()
            DispatchQueue.main.async {
                let price = UserDefaults(suiteName: "group.com.cnwang.wtkstock")?.double(forKey: "lastPrice") ?? 0.0
                
                UIApplication.shared.applicationIconBadgeNumber = lround(Double(price))
            }
            _ = service.checkAlarm()
        } //:Task
        
        
        
    } //: func
    
    func save(){
        print ("leaving homeview")
//        do{
//            let data = try JSONEncoder().encode(self.price)
//            UserDefaults(suiteName: "group.com.cnwang.wtkstock")?.set(data, forKey: "prices")
//            UserDefaults(suiteName: "group.com.cnwang.wtkstock")?.set((self.price.first?.deal ?? 0.0), forKey: "lastPrice")
//
//            UserDefaults(suiteName: "group.com.cnwang.wtkstock")?.set((self.price[1] == nil ? 0.0 : self.price[1].deal), forKey: "lastPrice2")
//
//
//        } catch {
//            UserDefaults(suiteName: "group.com.cnwang.wtkstock")?.set([], forKey: "prices")
//        }
        
    }
    
}
