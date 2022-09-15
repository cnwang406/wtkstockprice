//
//  SettingTextCellView.swift
//  wtkstockprice
//
//  Created by Chun nan Wang on 2022/9/15.
//

import SwiftUI

struct SettingTextCellView: View {
    //MARK: - PROPERTIES
    var title: String
    @Binding var result: String
    
    //MARK: - VIEW
    var body: some View {
        HStack{
            Text(title)
                .font(.title3)
            Spacer()
            TextField("", text: $result)
                .font(.title2)
                .padding()
                .background(.gray.opacity(0.3))
                .frame(width:180)
                
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }.padding()
            .frame(width: 350)
    }
}


//MARK: - PREVIEW
struct SettingTextCellView_Previews: PreviewProvider {
    static var previews: some View {
        SettingTextCellView(title: "Stock name",result: .constant("WTK"))
    }
}
