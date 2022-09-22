//
//  Service.swift
//  wtkstockprice
//
//  Created by Chun nan Wang on 2022/9/15.
//

import SwiftUI
import SwiftSoup
import Foundation
enum NetworkError : Error {
    case badURL
    case noData
    case badData
}

typealias Item = (text: String, html: String)


class Service: ObservableObject {
    var price: [Price] = []
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
        let urlString = "\(urlHead)\(stock_)"
        
        if self.loading {
            return
        }
        DispatchQueue.main.async {
            self.loading = true
        }
        
        guard let url = URL(string: "\(urlHead)\(stock_)") else {
            playNotificationHaptic(.error)
            fatalError("oops...\(urlString) not downloaded")
        }
        
        let config = URLSessionConfiguration.background(withIdentifier: "wtkstockloading")
        config.sessionSendsLaunchEvents = true
        let session = URLSession(configuration: config)
        let request = URLRequest(url: URL(string: urlString)!)
       
        self.html = try String.init(contentsOf: url)
        
        print ("\(Date()) finish loading from internet)")
    }
    
    
    
    
    func loadInBackgroundTask() async  {
        print ("loadInBackgroundTask()")
    

        print ("\(Date()) loaded")
        let urlString = "\(urlHead)\(stock_)"

        if self.loading {
            print ("already going")
            return
        }
        DispatchQueue.main.async {
            self.loading = true
        }

        guard let url = URL(string: "\(urlHead)\(stock_)") else {
            playNotificationHaptic(.error)
            print ("\(Date()) oops...\(urlString) not downloaded")
            fatalError("oops...\(urlString) not downloaded")
        }

        let config = URLSessionConfiguration.background(withIdentifier: "wtkstockloading")
        config.sessionSendsLaunchEvents = true
        let session = URLSession(configuration: config)
        let request = URLRequest(url: URL(string: urlString)!)

        let data =  await withTaskCancellationHandler {
            try? await session.data(for: request)
        } onCancel: {
            print ("onCancel")
            let task = session.downloadTask(with: request)
            task.resume()
        }


        if let data {
            self.html = String(data: data.0, encoding:  .utf8) ?? ""
            print ("\(Date()) download data ok \(data.0.count) bytes ")
        } else {
            print ("\(Date()) loadData fail!")

        }


    }
    
    
    func loadData2() async throws{
        print ("\(Date()) loaded")
        if self.loading {
            print ("already going")
            return
        }
        DispatchQueue.main.async {
            self.loading = true
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
            self.price = []
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
            self.price = []
        }
        do {
            print ("do -1")
            //empty old items
            document = try SwiftSoup.parse(html)
            
            let elements: Elements = try document.select( self.cssTextString)
            print ("do -2")
            for element in elements {
                let text = try element.text()
                let html = try element.outerHtml()
                items.append(Item(text: text, html: html))
            }
            self.priceMin = 1000.0
            print ("do -3")
            @State var tapCount = UserDefaults(suiteName: "group.com.cnwang.wtkstock")?.array(forKey: "aPrices")
            for item in 0..<items.count {
                let str = items[item].text
                if str.contains("聯穎光電"){
                    let arr = str.components(separatedBy: " ")
                    if arr.count == 6 {
                        let price = Price(id: UUID(), date: arr[0], buy: Double(arr[2]) ?? 0.0 , sell: Double(arr[3]) ?? 0.0, buyAmount: Int(arr[4]) ?? 0, sellAmount: Int(arr[5]) ?? 0)
                        priceMax = priceMax < price.sell ? price.sell : priceMax
                        priceMin = priceMin > price.buy ? price.buy  : priceMin
                        self.price.append(price)
                        
                    }
                }
            }
            UserDefaults(suiteName: "group.com.cnwang.wtkstock")?.set(self.price.first?.deal ?? 0.0, forKey: "lastPrice")
            if self.price[1] != nil {
                UserDefaults(suiteName: "group.com.cnwang.wtkstock")?.set(self.price[1].deal, forKey: "lastPrice2")
            } else {
                UserDefaults(suiteName: "group.com.cnwang.wtkstock")?.set(0.0, forKey: "lastPrice2")
            }
                
            
            print ("do -4")
            for item in 0..<self.price.count - 1 {
                self.price[item].priceUp = self.price[item].buy > self.price[item + 1] .buy
                
            }
            print ("do -5")
            DispatchQueue.main.async {
                self.loading = false
            }
            playNotificationHaptic(.success)
            print ("\(Date()) loadData done")
            //            return .success(items)
        } catch _ {
            print ("oops...parse fail")
            //            return .failure(.badData)
            playNotificationHaptic(.error)
        } //: catch
        
        
    }
}
