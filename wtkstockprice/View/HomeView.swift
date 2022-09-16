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
        GridItem(.flexible(minimum: 100.0), alignment: .topLeading),
        GridItem(.flexible(), alignment: .trailing),
        GridItem(.flexible(), alignment: .trailing),
        GridItem(.flexible(), alignment: .trailing),
        GridItem(.flexible(), alignment: .trailing)
    ]
    
    //MARK: - VIEW
    var body: some View {
        NavigationView {
            
        ZStack{
            VStack{
                
                LazyVGrid(columns: columns, spacing: 5) {
                    Group{
                        Text("Date")
                        Text("buy")
                        Text("sell")
                        Text("buy Amount")
                        Text("sell Amount")
                    }
                    .font(.headline)
                    
                    ForEach(service.price){ price in
                        Text("\(price.date)")
                        Text("$ \(price.buy, specifier: "%.2f")")
                        Text("$ \(price.sell, specifier: "%.2f")")
                        Text("\(price.buyAmount)")
                        Text("\(price.sellAmount)")
                        
                    }
                    .font(.system(size: 12.0))
                    
                    
                }
                .padding()
                ChartView()
                Spacer()
            }//: VStack
            
            if service.loading {
                ProgressView()
                    .scaleEffect(3.0)
            }
        }//:ZStack
        .onAppear{
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                
                if error != nil {
                    
                }

            }
            vm.load()
            let defaults = UserDefaults(suiteName: "group.com.cnwang.wtkstock")
            UserDefaults(suiteName: "group.com.cnwang.wtkstock")?.set(1, forKey: "count")
            let bgn =  Int(vm.price.first?.buy ?? 0)
   
            UIApplication.shared.applicationIconBadgeNumber = Int(vm.price.first?.buy ?? 0)
            let count_: Int = defaults?.value(forKey: "count") as! Int
            
            

            
        }
        .navigationTitle("聯穎光電 股價")
        }
    }
}


//MARK: - PREVIEW
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
