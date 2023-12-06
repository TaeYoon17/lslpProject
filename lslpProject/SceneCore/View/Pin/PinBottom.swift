//
//  PinBottom.swift
//  lslpProject
//
//  Created by 김태윤 on 12/6/23.
//

import SwiftUI
struct PinBottom:View{
    var body: some View{
        HStack{
            Image(systemName: "heart.square.fill")
                .font(.system(size: 24))
                .wrapBtn {
                print("Hello world")
            }
            Spacer()
            HStack{
                Button(action: {
                    print("Visit!!")
                }, label: {
                    Text("Visit")
                        .font(.title3.weight(.semibold))
                        .padding(.horizontal,8)
                        .padding(.vertical,6)
                        .frame(width: 68)
                }).accent(background: .regularMaterial)
                Button(action: {
                    print("Save!!")
                }, label: {
                    Text("Save").font(.title3.weight(.semibold))
                        .padding(.horizontal,8)
                        .padding(.vertical,6)
                        .frame(width: 68)
                        .foregroundStyle(.white)
                }).accent(background: .green)
                    .frame(maxWidth: 88)
            }
            Spacer()
            Image(systemName: "square.and.arrow.up.fill")
                .font(.system(size: 24))
                .wrapBtn {
                print("Hello world")
            }
        }
    }
}
