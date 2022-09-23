//
//  Service.swift
//  wtkstockprice
//
//  Created by Chun nan Wang on 2022/9/15.
//

import SwiftUI
import SwiftSoup
import Foundation
import WidgetKit
enum NetworkError : Error {
    case badURL
    case noData
    case badData
}
public enum NotifyMeStatus:Int {
    case noData = 0
    case high = 1
    case low = 2
    case peace = 3
}
typealias Item = (text: String, html: String)
struct Price: Codable,Hashable, Identifiable {
    var id: UUID
    var date: String
    var buy: Double
    var sell: Double
    var buyAmount: Int
    var sellAmount: Int
    var buyDiff: Double {
        (sell - buy)
    }
    var deal: Double{
        (buy + sell) / 2
    }
    
    var priceUp: Bool = true
}

class Service: ObservableObject {
    var prices: [Price] = []
    var priceMax:Double = 0.0
    var priceMin:Double = 0.0
    @Published var loading: Bool = false
    static var shared = Service()
    
    var urlHead: String = "https://www.goodstock.com.tw/stock_quote.php?stockname="
    var stock_: String = "%E8%81%AF%E7%A9%8E%E5%85%89%E9%9B%BB"
    var stock: String = "聯穎光電"
    var lll: String = "https%3A%2F%2Fwww.goodstock.com.tw%2Fstock_quote.php%3Fstockname%3D"
    var cssTextString : String = "tr"
    
    var html: String = ""
    
    // item founds
    
  
    
    func loadData() async throws{
        print ("\(Date()) loaded")
        if self.loading {
            print ("already going")
            return
        }
        DispatchQueue.main.async {
            self.loading = true
        }
        
        do{
            if let data = UserDefaults(suiteName: "group.com.cnwang.wtkstock")?.data(forKey: "prices") {
                self.prices = try JSONDecoder().decode([Price].self, from: data)
            }
        } catch {
            self.prices = []
        }
        
        
        let urlString = "\(urlHead)\(stock_)"
        
        guard let url = URL(string: "\(urlHead)\(stock_)") else {
            playNotificationHaptic(.error)
            print ("\(Date()) oops...\(urlString) not downloaded")
            fatalError("oops...\(urlString) not downloaded")
        }
        
        print ("\(Date()) loading url from \(url)")
        self.html = try String.init(contentsOf: url) // get data from internet
        DispatchQueue.main.async {
            self.loading = true
            self.prices = []
        }
        
        print ("\(Date()) finish loading from internet)")
    }
    
    
    
    func parse(){
        
        var document: Document = Document.init("")
        var items: [Item] = []
        print ("\(Date()) loaded url done. start to parse")
        if self.html == "" {
            print ("\(Date()) html is empty. return")
            return
        }
        DispatchQueue.main.async {
            self.prices = []
        }
        do {
            //empty old items
            document = try SwiftSoup.parse(html)
            
            let elements: Elements = try document.select( self.cssTextString)
            for element in elements {
                let text = try element.text()
                let html = try element.outerHtml()
                items.append(Item(text: text, html: html))
            }
            self.priceMin = 1000.0
//            @State var tapCount = UserDefaults(suiteName: "group.com.cnwang.wtkstock")?.array(forKey: "aPrices")
            for item in 0..<items.count {
                let str = items[item].text
                if str.contains("聯穎光電"){
                    let arr = str.components(separatedBy: " ")
                    if arr.count == 6 {
                        let price = Price(id: UUID(), date: arr[0], buy: Double(arr[2]) ?? 0.0 , sell: Double(arr[3]) ?? 0.0, buyAmount: Int(arr[4]) ?? 0, sellAmount: Int(arr[5]) ?? 0)
                        priceMax = priceMax < price.sell ? price.sell : priceMax
                        priceMin = priceMin > price.buy ? price.buy  : priceMin
                        self.prices.append(price)
                        
                    }
                }
            }
            
            
            for item in 0..<self.prices.count - 1 {
                self.prices[item].priceUp = self.prices[item].buy > self.prices[item + 1] .buy
                
            }
            do{
                let data = try JSONEncoder().encode(self.prices)
                UserDefaults(suiteName: "group.com.cnwang.wtkstock")?.set(data, forKey: "prices")
                UserDefaults(suiteName: "group.com.cnwang.wtkstock")?.set((self.prices.first?.deal ?? 0.0), forKey: "lastPrice")
                
                UserDefaults(suiteName: "group.com.cnwang.wtkstock")?.set((self.prices[1] == nil ? 0.0 : self.prices[1].deal), forKey: "lastPrice2")
                
                
            } catch {
                UserDefaults(suiteName: "group.com.cnwang.wtkstock")?.set([], forKey: "prices")
            }
            
            
            
            DispatchQueue.main.async {
                self.loading = false
            }
            playNotificationHaptic(.success)
            print ("\(Date()) loadData done")
            UserDefaults(suiteName: "group.com.cnwang.wtkstock")?.set(Date().timeIntervalSince1970, forKey: "lastUpdated")
            var count = UserDefaults(suiteName: "group.com.cnwang.wtkstock")?.integer(forKey: "count") ?? 0
            UserDefaults(suiteName: "group.com.cnwang.wtkstock")?.set(count + 1, forKey: "count")
            
            UserDefaults(suiteName: "group.com.cnwang.wtkstock")?.set(checkAlarm().rawValue, forKey: "check")
            
            WidgetCenter.shared.reloadAllTimelines()
            
            //            return .success(items)
        } catch _ {
            print ("oops...parse fail")
            //            return .failure(.badData)
            playNotificationHaptic(.error)
        } //: catch
        
        
    }
    
    func checkAlarm() -> NotifyMeStatus {
        let low = UserDefaults(suiteName: "group.com.cnwang.wtkstock")?.double(forKey: "priceLow") ?? 100.0
        let high = UserDefaults(suiteName: "group.com.cnwang.wtkstock")?.double(forKey: "priceHigh") ?? 150.0
        let price = UserDefaults(suiteName: "group.com.cnwang.wtkstock")?.double(forKey: "lastPrice") ?? 0.0
        if (UserDefaults(suiteName: "group.com.cnwang.wtkstock")?.bool(forKey: "notifyMe") ?? true) {
            if price == 0.0 {
                return .noData
            }
            if price <= low {
                print ("now \(price) <= \(low) , LOW ALARM !!!")
                return .low
            } else if price >= high {
                print ("now \(price) >= \(high) , HIGH ALARM !!!")
                return .high
            }
        }
        
        
        return .peace
    }
}
