//
//  ViewOptionSection.swift
//  lslpProject
//
//  Created by 김태윤 on 12/25/23.
//

import SwiftUI

struct ViewOptionSection<T:View>:View{
    let header: String
    let item: ()->T
    var body: some View{
        VStack(spacing:16){
            EmptyView()
            HStack{
                Text(header).font(.subheadline)
                Spacer()
                
            }
            item()
        }
    }
}
