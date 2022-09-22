//
//  PriceCircleView.swift
//  wtkstockprice
//
//  Created by Chun nan Wang on 2022/9/22.
//

import SwiftUI
import WidgetKit
struct PriceCircleView: View {
    //MARK: - PROPERTIES
    @State var scale =  1.0
    @State var ratio: Double = 0.75
    var lastPrice:Double = UserDefaults(suiteName: "group.com.cnwang.wtkstock")?.double(forKey: "lastPrice") ?? 150.0
    var lastPrice2:Double = UserDefaults(suiteName: "group.com.cnwang.wtkstock")?.double(forKey: "lastPrice2") ?? 150.0
    var targetPrice: Double = 150.0
    var share: Double =  UserDefaults(suiteName: "group.com.cnwang.wtkstock")?.double(forKey: "share") ?? 0.0
    var check: Int = UserDefaults(suiteName: "group.com.cnwang.wtkstock")?.integer(forKey: "check") ?? 3
    var low = UserDefaults(suiteName: "group.com.cnwang.wtkstock")?.double(forKey: "priceLow") ?? 100.0
    var high = UserDefaults(suiteName: "group.com.cnwang.wtkstock")?.double(forKey: "priceHigh") ?? 150.0
    //MARK: - VIEW
    var body: some View {
        GeometryReader{ geometry in
           
            ZStack(alignment: .top){
                HStack{
                    Text("\(lastPrice2, specifier: "%3.1f")")
                        .opacity(lastPrice2 == 0 ? 0.5 : 1.0)
                    Spacer()
                    if lastPrice * lastPrice2 != 0.0 {
                        
                        Text("\(((lastPrice - lastPrice2) / lastPrice2) * 100, specifier: "%2.1f")%")
                            .foregroundColor(lastPrice > lastPrice2 ? .red : .green)
                    } else {
                        Text("-- %")
                            .opacity(0.5)
                    }
                }
                .offset(y:-geometry.size.height * 0.05)
                .padding(.vertical,5)
                .padding(.horizontal,5)
                
                Circle()
                    .trim(from: 0.0, to: 0.5)
                    .stroke(style: StrokeStyle(lineWidth: 55.0 * scale , lineCap: .round, lineJoin: .round))
                    .rotationEffect(Angle(degrees: 180.0))
                    .opacity(0.2)
                    .foregroundColor(ratio > 0.7 ? .green : .red)
                    
                    .frame(width: geometry.size.width * 0.9,  height:geometry.size.width * 0.9)
                    .offset(x: geometry.size.width * 0, y: geometry.size.height * 0.14)
                Circle()
//                    .trim(from: 0.0, to: CGFloat( ratio ))
                
                    .trim(from: 0.0, to: ratio / 2)
                    .stroke(style: StrokeStyle(lineWidth: 53.0 * scale , lineCap: .round, lineJoin: .round))
                    .rotationEffect(Angle(degrees: 180.0))
                    .foregroundColor((lastPrice / targetPrice) >= 1.0 ? .red : .green)
                    .animation(.interactiveSpring(), value: ratio)
                    .opacity(ratio)
                    .frame(width: geometry.size.width * 0.9,  height:geometry.size.width * 0.9)
                    .offset(x: geometry.size.width * 0,y: geometry.size.height * 0.14)
                


                Text("\(lastPrice, specifier: "%0.1f")")
                    .font(.system(size:  72.0 * scale))
                    .fontWeight(.bold)
                    .foregroundColor(lastPrice > lastPrice2 ? .red : .green)
        //                    .fontWeight(.bold)
                    .opacity(lastPrice == 0 ? 0.5 : 1.0)
                    .offset(y: geometry.size.height * 0.33)
                
                Text("$\(lastPrice * share * 1000, specifier: "%0.0f").")
                    .font(.system(size:  48.0 * scale))
                    .fontWeight(.bold)
                    .foregroundColor(lastPrice > lastPrice2 ? .red : .green)
        //                    .fontWeight(.bold)
                    .opacity(0.8)
                    .offset(y: geometry.size.height * 0.60)
                let moneyGain = lastPrice - lastPrice2
                Text("$\(moneyGain * share * 1000, specifier: "%0.0f").")
                    .font(.system(size:  36.0 * scale))
//                    .fontWeight(.bold)
                    .foregroundColor(moneyGain > 0 ? .red : .green)
        //                    .fontWeight(.bold)
                    .opacity(0.8)
                    .offset(y: geometry.size.height * 0.75)
//                HStack{
//                    Text("\(Int(low))~\(Int(high))")
//                        .font(.footnote)
//                }

            }
            .onAppear {
                withAnimation {
                    print ("lastprice = \(lastPrice)")
                    ratio = lastPrice / targetPrice
//                    scale = (ratio > 1.1 || ratio < 0.9) ? 1.3 : 0.7
                    
                }
            }
           
            
        }
    }
}


//MARK: - PREVIEW
struct PriceCircleView_Previews: PreviewProvider {
    static var previews: some View {
        PriceCircleView()
            .previewLayout(.sizeThatFits)
    }
}
