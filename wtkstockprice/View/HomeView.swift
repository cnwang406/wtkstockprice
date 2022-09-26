//
//  HomeView.swift
//  wtkstockprice
//
//  Created by Chun nan Wang on 2022/9/15.
//

import SwiftUI

struct HomeView: View {
    //MARK: - PROPERTIES
    @ObservedObject var vm = HomeViewModel()
    @ObservedObject var service = Service.shared
    

    
    let columns = [
        GridItem(.flexible(minimum: 80.0), alignment: .topLeading),
        GridItem(.flexible(), alignment: .trailing),
        GridItem(.flexible(), alignment: .trailing),
        GridItem(.flexible(), alignment: .trailing),
        GridItem(.flexible(), alignment: .trailing)
    ]
    
    //MARK: - VIEW
    var body: some View {
        NavigationView {
            if service.validStock {
                ZStack{
                    VStack{
                        
                        LazyVGrid(columns: columns, alignment: .center, spacing: 5) {
                            Group{
                                Text("Date")
                                Text("buy")
                                Text("sell")
                                Text("buy Amt")
                                Text("sell Amt")
                            }
                            .font(.system(size: 14.0))
                            .fontWeight(.semibold)
                            
                            ForEach(service.prices){ price in
                                
                                Text("\(price.date)")
                                Text("$ \(price.buy, specifier: "%.2f")")
                                Text("$ \(price.sell, specifier: "%.2f")")
                                Text("\(price.buyAmount)")
                                Text("\(price.sellAmount)")
                                
                            }
                            .redacted(reason: (service.loading || !service.validStock) ? .placeholder : [])
                            .font(.system(size: 12))
                            
                            
                        }
                        .padding()
                        ChartView()
                            .redacted(reason: (service.loading || !service.validStock) ? .placeholder : [])
                                                .frame(height: 230)
                        Spacer()
                        let last1970 = UserDefaults(suiteName: groupIdentifier)?.double(forKey: "lastUpdated") ?? 0.0
                        Text("last update \(Date(timeIntervalSince1970: last1970).formatted())")
                            .font(.caption)
                            .opacity(0.8)
                    }//: VStack
                    
                    if service.loading {
                        ProgressView()
                            .scaleEffect(3.0)
                    }

                    
                }//:ZStack
                .navigationTitle("\(vm.service.stock)")
                
            } else {
                InvalidStockView()
                
            }//: if service.validStock
        }
        .onAppear{
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                if error != nil {
                }
            }
            vm.load()
        }
        .onDisappear {
            vm.save()
        }
    }
}


//MARK: - PREVIEW
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
