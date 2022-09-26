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
                    .onSubmit {
                        //                        print (vm.stock)
                        print (vm.stock)
                    }
                VStack{
                    Text("source: 好股網")
                    Link("https://www.goodstock.com.tw/" + (vm.stock.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed) ?? ""), destination: URL(string: "https://www.goodstock.com.tw/" +  (vm.stock.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed) ?? "") )!)
                    
                }
                .font(.footnote)
                
                Divider()
                VStack(spacing:0){
                    withAnimation {
                        Toggle(isOn: $vm.notifyMe, label: {
                            Text("超出範圍通知我")
                        }).font(.title3)
                            .padding()
                            .frame(width: 350)
                    }
                    Text("因為是app的背景工作,可能會有時間差")
                        .font(.footnote)
                        .fontWeight(.light).opacity(0.5)
                    HStack{
                        Text("\(Image(systemName: "arrow.up.to.line"))")
                        Slider(value: $vm.priceHigh, in: (vm.priceLow + 1)...350,step: 1.0) {
                            Text("slider")
                        } minimumValueLabel: {
                            Text("\(vm.priceLow, specifier: "%0.f")")
                        } maximumValueLabel: {
                            Text("350")
                        }
                        .opacity(vm.notifyMe ? 1.0 : 0.3)
                        .disabled(!vm.notifyMe)
                        //                    .padding()
                    }
                    .frame(width:350)
                    .padding()
                    
                    Text("\(vm.priceLow, specifier: "%0.f") ~ \(vm.priceHigh, specifier: "%0.f")")
                        .font(.title3)
                        .opacity(vm.notifyMe ? 1.0 : 0.3)
                        .frame(width:350)
                        .disabled(!vm.notifyMe)
                    HStack{
                        Text("\(Image(systemName: "arrow.down.to.line"))")
                        Slider(value: $vm.priceLow, in: 0...(vm.priceHigh <= 1 ? 10.0 : vm.priceHigh - 1),step: 1.0) {
                            Text("slider")
                        } minimumValueLabel: {
                            Text("0")
                        } maximumValueLabel: {
                            Text("\(vm.priceHigh, specifier: "%03.f")")
                        }
                        .disabled(!vm.notifyMe)
                        .opacity(vm.notifyMe ? 1.0 : 0.3)
                        //                    .padding()
                    }
                    .frame(width:350)
                    .padding()
                }
                
                Spacer()
                
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
                    }
                    .frame(width:350)
                    .padding()
                    
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
