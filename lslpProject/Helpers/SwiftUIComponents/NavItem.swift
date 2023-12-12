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
struct LabelNavi<B:View>: View{
    var navItem: (() ->  NavItem<B>)
    var labelName:String
    init(label:String,navItem: @escaping (() -> NavItem<B>)) {
        self.labelName = label
        self.navItem = navItem
    }
    var body: some View{
        VStack(alignment: .leading,spacing: 4){
            Text(labelName).font(.subheadline)
            navItem()
        }
    }
}
