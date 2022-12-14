//
//  ChartView.swift
//  wtkstockprice
//
//  Created by Chun nan Wang on 2022/9/16.
//

import SwiftUI
import Charts
struct ChartView: View {
    //MARK: - PROPERTIES
    @StateObject var service = Service.shared
    @ObservedObject var vm = ChartViewModel()
    @State var mag = 1.0
    @State var scale: Double = 10.0
    @State var oldMag: Double = 0.0
    @State var upper:Double = 100.0
    @State var lower:Double = 0.0
    
    //MARK: - VIEW
    var body: some View {
        
        VStack(spacing: 0){
            Text("\(service.stock)")
                .font(.caption)
                .fontWeight(.semibold)
            
            Chart{
                ForEach (service.prices.reversed()) { price in
                    BarMark(
                        x: .value("Date", String(price.date.suffix(2) )),
                        y: .value("buy", price.buy)
                    )
                    .foregroundStyle(.clear)
                    .symbol(.circle)
                }
                ForEach (service.prices.reversed()) { price in
                    BarMark(
                        x: .value("Date", String(price.date.suffix(2) )),
                        y: .value("sell", price.buyDiff)
                    )
                    .foregroundStyle(price.date.isWeekend() ? .gray : ( price.priceUp ? .red.opacity(0.7) : .green.opacity(0.7)))
                    .symbol(.square)
                }
                
                ForEach  (service.prices.reversed()) { price in
                    LineMark(
                        x: .value("Date", String(price.date.suffix(2) )),
                        y: .value("avg", price.deal)
                    )
                    .symbol(.circle)
                    .foregroundStyle(price.priceUp ? .red.opacity(0.7) : .green.opacity(0.7))
                }
                
            } //: Chart
            .chartLegend(.visible)
            .chartXAxisLabel("Date")
            .chartPlotStyle { plotArea in
                plotArea
                    .background (.orange.opacity (0.1))
                    .border(.orange, width: 2)
            }
            .chartYAxisLabel("$")
            .chartYScale(domain: (vm.yMin)...(vm.yMax))
            
            .onTapGesture(count: 1, perform: {
                withAnimation {
                    
                    if vm.yMin == 0.0 {
                        vm.yMin = service.priceMin * 0.9
                        vm.yMax = service.priceMax * 1.1
                    } else {
                        
                        vm.yMin = 0.0
                        vm.yMax = service.priceMax * 1.2
                        
                    }
                }
    
                
            })
        }
        .padding()
        .background(.blue.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding()
    }
}

extension String {
    func isWeekend() -> Bool {
        let dateFormatter = DateFormatter()
        //          dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let date = dateFormatter.date(from:self) ?? Date()
        
        let date2 = (Calendar.current.dateComponents([.weekday], from: date)).weekday ?? 2
        //                print ("convert \(self) to \(date) \(date2)")
        
        return (date2 == 1 ) || (date2 == 7)
    }
}

//MARK: - PREVIEW
struct ChartView_Previews: PreviewProvider {
    
    static var previews: some View {
        ChartView()
        
    }
    
}
