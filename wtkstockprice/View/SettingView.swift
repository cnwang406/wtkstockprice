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
                Spacer()
                Text("Pending Tasks")
                List(self.l,id:\.self) { ll in
                    Text(ll)
                }
                
                
                    
                
            }
            .navigationTitle("Setting")
        }
        .onAppear {
            let t = BGTaskScheduler.shared.getPendingTaskRequests { r in
                print ("pending task count = \(r.count)")
                self.l = []
                for rr in r {
                    print("prendingTask = \(rr)")
                    self.l.append(String(rr.description))
                }
    //            BGTaskScheduler.shared.cancelAllTaskRequests()
            }
        }
        
    }
}


//MARK: - PREVIEW
struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
