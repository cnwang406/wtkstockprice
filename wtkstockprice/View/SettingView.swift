//
//  SettingView.swift
//  wtkstockprice
//
//  Created by Chun nan Wang on 2022/9/15.
//

import SwiftUI
import BackgroundTasks

struct SettingView: View {
    //MARK: - PROPERTIES
    @ObservedObject var vm = SettingViewModel()
    @State var l: [String] = []
    @State var shareS: String = "0.0"
    //MARK: - VIEW
    var body: some View {
        
        NavigationView(){
            
            VStack{
                
                SettingTextCellView(title: "股票名稱", result: $vm.stock)
                withAnimation {
                    
                    Toggle(isOn: $vm.notifyMe, label: {
                        Text("超出範圍通知我")
                    }).font(.title3)
                        .padding()
                        .frame(width: 350)
                }
                
                VStack(spacing:0){
                    
                    Slider(value: $vm.priceHigh, in: 2...350,step: 1.0) {
                        Text("slider")
                    } minimumValueLabel: {
                        Text("\(vm.priceLow, specifier: "%0.f")")
                    } maximumValueLabel: {
                        Text("350")
                    } onEditingChanged: { changed in
                        if changed {
                            if vm.priceHigh <= vm.priceLow {
                                vm.priceLow = vm.priceHigh - 1
                            }
                            
                        }
                    }
                    .onChange(of: vm.priceHigh, perform: { newValue in
                        vm.priceHigh = (newValue <= vm.priceLow ? vm.priceLow + 1 : newValue)
                    })
                    .opacity(vm.notifyMe ? 1.0 : 0.7)
                    .disabled(!vm.notifyMe)
                    .padding()
                    .frame(width:350)
                    
                    Text("\(vm.priceLow, specifier: "%0.f") ~ \(vm.priceHigh, specifier: "%0.f")")
                        .font(.title3)
                        .opacity(vm.notifyMe ? 1.0 : 0.7)
                        .frame(width:350)
                        .disabled(!vm.notifyMe)
                    
                    Slider(value: $vm.priceLow, in: 1...349,step: 1.0) {
                        Text("slider")
                    } minimumValueLabel: {
                        Text("0")
                    } maximumValueLabel: {
                        Text("\(vm.priceHigh, specifier: "%03.f")")
                    } onEditingChanged: { changed in
                        if changed{
                            
                            if vm.priceLow >= vm.priceHigh {
                                vm.priceLow = vm.priceHigh - 1
                            }
                            
                        }
                    }
                    .onChange(of: vm.priceLow, perform: { newValue in
                        vm.priceLow = (newValue >= vm.priceHigh ? vm.priceHigh - 1 : newValue)
                    })
                    
                    .disabled(!vm.notifyMe)
                    .opacity(vm.notifyMe ? 1.0 : 0.7)
                    .padding()
                    .frame(width:350)
                    
                    .padding()
                }
                
                Spacer()
//                Group{
//                    
//                    Text("price \(UserDefaults(suiteName: groupIdentifier)?.double(forKey: "lastPrice") ?? 0.0)")
//                    Text("last Price2 \(UserDefaults(suiteName: groupIdentifier)?.double(forKey: "lastPrice2") ?? 0.0)")
//                    Text("high \(UserDefaults(suiteName: groupIdentifier)?.double(forKey: "priceHigh") ?? 0.0)")
//                    Text("low \(UserDefaults(suiteName: groupIdentifier)?.double(forKey: "priceLow") ?? 0.0)")
//                    Text("share \(UserDefaults(suiteName: groupIdentifier)?.double(forKey: "share") ?? 0.0)")
//                    
//                    
//                    Text("update times \(UserDefaults(suiteName: groupIdentifier)?.integer(forKey: "count") ?? 0)")
//                    
//                    
//                    
//                }
                VStack(spacing:0){
                    
                    
                    SettingTextCellView(title: "張數(最多50)", result: $shareS)
                        .onSubmit {
                            vm.share = Double(shareS) ?? 0.0
                            shareS = String(vm.share)
                            
                            
                        }
                    
                    Slider(value: $vm.share, in: 0...50 ,step: 0.001) {
                        Text("slider")
                    } minimumValueLabel: {
                        Text("")
                    } maximumValueLabel: {
                        Text("\(vm.share, specifier: "%3.3f")")
                    } onEditingChanged: { changed in
                        if changed{
                            UserDefaults(suiteName: groupIdentifier)?.set(vm.share, forKey: "share")
                            
                        }
                    }
                    .padding()
                    .frame(width:350)
                    
                }
                
                Text("last update \(Date(timeIntervalSince1970: UserDefaults(suiteName: groupIdentifier)?.double(forKey: "lastUpdated") ?? 0.0).formatted())")
                Spacer()
                Text("by cnwang \(UIApplication.appVersion!) build \(UIApplication.appBuildVersion!)")
                    .font(.footnote)
                
                
                
                
            }
            .navigationTitle("Setting")
        }
        .onAppear {
            
            shareS = String(vm.share)
            
        }
        .onDisappear {
            vm.commit()
        }
        
    }
}


//MARK: - PREVIEW
struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
