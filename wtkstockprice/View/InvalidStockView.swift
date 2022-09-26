//
//  InvalidStockView.swift
//  wtkstockprice
//
//  Created by Chun nan Wang on 2022/9/26.
//

import SwiftUI

struct InvalidStockView: View {
    //MARK: - PROPERTIES
    
    
    //MARK: - VIEW
    var body: some View {
        VStack{
            Image(systemName: "exclamationmark.triangle.fill")
                .resizable()
                .scaledToFit()
                .foregroundColor(.yellow)
//                .scaleEffect(1.0)
//                .frame(width: 300, height: 300)
            Text("Invlid Stock")
                .font(.title2)
                .fontWeight(.bold)
            Text("check in setting")
                .font(.title3)
        } //: VStack
            
    }
}


//MARK: - PREVIEW
struct InvalidStockView_Previews: PreviewProvider {
    static var previews: some View {
        InvalidStockView()
    }
}
