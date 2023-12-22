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
                .font(.system(size: 28))
                .wrapBtn {
                print("Hello world")
            }
            Spacer()
            HStack(alignment:.center){
                Button(action: {
                    print("Visit!!")
                }, label: {
                    Text("Visit")
                        .font(.title3.weight(.semibold))
                        .padding(.all,12)
                        .padding(.horizontal,4)
                        .background(.regularMaterial)
                        .clipShape(Capsule())
                }).tint(.text)
                Button(action: {
                    print("Save!!")
                }, label: {
                    Text("Save").font(.title3.weight(.semibold))
                        .padding(.all,12)
                        .padding(.horizontal,4)
                        .background(.green)
                        .clipShape(Capsule())
                }).tint(.white)
                    
            }
            Spacer()
            Image(systemName: "square.and.arrow.up.fill")
                .font(.system(size: 28))
                .wrapBtn {
                print("Hello world")
            }
        }
    }
}
#Preview(body: {
    NavigationStack {
        PinView(image: "Metal").environmentObject(DiscoverVM())
    }
})

