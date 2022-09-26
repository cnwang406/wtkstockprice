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
    var lastPrice:Double = UserDefaults(suiteName: groupIdentifier)?.double(forKey: "lastPrice") ?? 150.0
    var lastPrice2:Double = UserDefaults(suiteName: groupIdentifier)?.double(forKey: "lastPrice2") ?? 150.0
    var share: Double =  UserDefaults(suiteName: groupIdentifier)?.double(forKey: "share") ?? 0.0
    var check: Int = UserDefaults(suiteName: groupIdentifier)?.integer(forKey: "check") ?? 3
    var low = UserDefaults(suiteName: groupIdentifier)?.double(forKey: "priceLow") ?? 100.0
    var high = UserDefaults(suiteName: groupIdentifier)?.double(forKey: "priceHigh") ?? 150.0
    var lastUpdate1970 =  UserDefaults(suiteName: groupIdentifier)?.double(forKey: "lastUpdated") ?? 0.0
    //MARK: - VIEW
    var body: some View {
        GeometryReader{ geometry in
            
            ZStack(alignment: .top){
                HStack{
                    
                    Text("\(lastPrice2, specifier: "%3.1f")")
                        .opacity((1 - (Date().timeIntervalSince1970 - lastUpdate1970) / 86400) * 0.9 + 0.1)
                    Spacer()
                    if lastPrice * lastPrice2 != 0.0 {
                        
                        Text("\(((lastPrice - lastPrice2) / lastPrice2) * 100, specifier: "%2.1f")%")
                            .foregroundColor(lastPrice >= lastPrice2 ? .red : .green)
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
                    .stroke(style: StrokeStyle(lineWidth: 13.0 , lineCap: .round, lineJoin: .round))
                    .rotationEffect(Angle(degrees: 180.0))
                    .foregroundColor(.gray)
                    .opacity(0.2)
                    .frame(width: geometry.size.width * 0.9,  height:geometry.size.width * 0.9)
                    .offset(x: geometry.size.width * 0, y: geometry.size.height * 0.14)
                let gradient = AngularGradient(gradient: Gradient(colors: [.green, .yellow, .red]), center: .center, startAngle: .degrees(45), endAngle: .degrees(135))
                Circle()
                
                    .trim(from: 0.0, to: ratio / 2)
                    .stroke(gradient, style: StrokeStyle(lineWidth: 17.0  , lineCap: .round, lineJoin: .round))
                    .rotationEffect(Angle(degrees: 180.0))
                    .opacity(0.7)
                    .frame(width: geometry.size.width * 0.9,  height:geometry.size.width * 0.9)
                    .offset(x: geometry.size.width * 0,y: geometry.size.height * 0.14)
                
                Text("\(lastPrice, specifier: "%0.1f")")
                    .font(.system(size:  30.0))
                    .fontWeight(.bold)
                    .foregroundColor(lastPrice > lastPrice2 ? .red : .green)
                    .opacity(lastPrice == 0 ? 0.5 : 1.0)
                    .animation(.interactiveSpring(response: 3.0, dampingFraction: 0.1), value: scale)
                    .scaleEffect(scale)
                    .offset(y: geometry.size.height * 0.30)
                
                Text("$\(lastPrice * share * 1000, specifier: "%0.0f").")
                    .font(.system(size:  18.0))
                    .fontWeight(.bold)
                    .foregroundColor(lastPrice > lastPrice2 ? .red : .green)
                    .opacity(0.8)
                    .offset(y: geometry.size.height * 0.56)
                
                let moneyGain = lastPrice - lastPrice2
                Text("$\(moneyGain * share * 1000, specifier: "%0.0f").")
                    .font(.system(size:  12.0))
                    .foregroundColor(moneyGain > 0 ? .red : .green)
                    .opacity(0.8)
                    .offset(y: geometry.size.height * 0.75)
                HStack{
                    Text("\(low, specifier: "%3.0f")").font(.system(size: 6))
                        .foregroundColor(.green.opacity(lastPrice <= low ? 1.0 : 0.7))
                        .animation(.spring(response: 5.0, dampingFraction: 0.1), value: scale)
                        .scaleEffect(scale)
                        .padding(.leading, 3)
                    Spacer()
                    Text("\(high, specifier: "%3.0f")").font(.system(size: 6))
                        .foregroundColor(.red.opacity(lastPrice >= high ? 1.0 : 0.7))
                        .animation(.spring(response: 5.0, dampingFraction: 0.1), value: scale)
                        .scaleEffect(scale)
                        .padding(.trailing, 3)
                    
                }
                .offset(y: geometry.size.height * 0.83)
                .onTapGesture {
                    
                }
                
                
                
            }
            .onAppear {
                withAnimation {
                    print ("lastprice = \(lastPrice) / \(high)")
                    ratio = (lastPrice - low) / (high - low )
                    if ratio < 0.0 {
                        ratio = 0.01
                    }
                    if ratio > 1.0 {
                        ratio = 1.0
                    }
                    //                    scale = (ratio > 1.1 || ratio < 0.9) ? 1.3 : 0.7
                    scale = lastPrice > high ? 1.2 : (lastPrice <= low ? 1.2 : 1.0 )
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
