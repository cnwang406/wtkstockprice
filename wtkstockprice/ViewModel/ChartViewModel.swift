//
//  ChartViewModel.swift
//  wtkstockprice
//
//  Created by Chun nan Wang on 2022/9/26.
//

import SwiftUI

class ChartViewModel: ObservableObject {
    @Published var yMax: Double = 100.0
    @Published var yMin: Double = 0.0
    @ObservedObject var service = Service.shared
    
    @Published var scale: Double = 1.0
    
    init(){
        self.yMax = service.priceMax * 1.1
        self.yMin =  service.priceMin * 0.9
    }
}
