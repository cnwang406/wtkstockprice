//
//  HomeViewModel.swift
//  wtkstockprice
//
//  Created by Chun nan Wang on 2022/9/15.
//

import SwiftUI

struct Price: Codable,Hashable, Identifiable {
    var id: UUID
    var date: String
    var buy: Float
    var sell: Float
    var buyAmount: Int
    var sellAmount: Int
}
class HomeViewModel: ObservableObject {
    @Published var price: [Price] = []
    @Published var ret: [Item] = []
    
    
    
    var service = Service.shared
    init(){
        
    }

 
    func load() {
        Task {
            
            try await service.loadData()

            DispatchQueue.main.async {
                let price = self.service.price.first?.buy ?? 0.0
                UIApplication.shared.applicationIconBadgeNumber = lround(Double(price))
            }
        }
        
    }
    
    func getStocks(){
        
        
    }
}
