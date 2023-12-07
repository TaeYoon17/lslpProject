//
//  NaviLink.swift
//  lslpProject
//
//  Created by 김태윤 on 12/7/23.
//

import SwiftUI
struct NavItem<B:View>: View{
    @ViewBuilder var accessory: (()-> B)
    var text: String
    init(_ text:String,accessory:@escaping (()->B) = {
        EmptyView()
    }){
        self.text = text
        self.accessory = accessory
    }
    var body: some View{
        HStack{
            Text(text).font(.title3.bold())
            Spacer()
            HStack{
                accessory()
            }.bold()
        }
    }
}
