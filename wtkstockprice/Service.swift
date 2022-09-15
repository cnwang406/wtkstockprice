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
    @Published var loading: Bool = false
    static var shared = Service()
    
    var urlHead: String = "https://www.goodstock.com.tw/stock_quote.php?stockname="
    var stock_: String = "%E8%81%AF%E7%A9%8E%E5%85%89%E9%9B%BB"
    var stock: String = "聯穎光電"
    var lll: String = "https%3A%2F%2Fwww.goodstock.com.tw%2Fstock_quote.php%3Fstockname%3D"
    var cssTextString : String = "tr"
    
    // item founds
    
    func loadData() async throws{
        var document: Document = Document.init("")
        var items: [Item] = []
        
        print ("loaded")

        if loading { return}
        
        let urlString = "\(urlHead)\(stock_)"
        
        guard let url = URL(string: "\(urlHead)\(stock_)") else {
            fatalError("oops...\(urlString) not downloaded")
        }


        do {
            //empty old items
            let html = try String.init(contentsOf: url) // get data from internet
            DispatchQueue.main.async {
                self.loading = true
                self.price = []
            }
            
            document = try SwiftSoup.parse(html)
            
            let elements: Elements = try document.select( self.cssTextString)
            
            for element in elements {
                let text = try element.text()
                let html = try element.outerHtml()
                items.append(Item(text: text, html: html))
            }
            
            for item in 0..<items.count {
                let str = items[item].text
                if str.contains("聯穎光電"){
                    let arr = str.components(separatedBy: " ")
                    if arr.count == 6 {

                        let price = Price(id: UUID(), date: arr[0], buy: Float(arr[2]) ?? 0.0 , sell: Float(arr[3]) ?? 0.0, buyAmount: Int(arr[4]) ?? 0, sellAmount: Int(arr[5]) ?? 0)
                        self.price.append(price)
                    }
                }
            }
            
            DispatchQueue.main.async {
                self.loading = false
            }
            
            //            return .success(items)
        } catch _ {
            print ("oops...parse fail")
            //            return .failure(.badData)
            
        } //: catch
        
        
    }
    
}
