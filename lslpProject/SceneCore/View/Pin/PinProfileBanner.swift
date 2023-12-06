//
//  PinBannerView.swift
//  lslpProject
//
//  Created by 김태윤 on 12/6/23.
//

import Foundation
import SwiftUI
struct PinProfileBanner: View{
    var body:some View{
        HStack {
            Image("lgWin")
                .resizable()
                .scaledToFit()
                .frame(width: 48,height: 48,alignment:.leading)
                .padding(.all,4)
                .background(.white)
                .clipShape(Circle())
            VStack(alignment:.leading){
                Text("Afnan").font(.headline)
                Text("200 followers").font(.subheadline)
            }
            Spacer()
            Button {
                print("하이염")
            } label: {
                Text("Follow").font(.headline.weight(.medium))
            }.accent(background: .blue)
        }
    }
}
