//
//  PinImageSlider.swift
//  lslpProject
//
//  Created by 김태윤 on 12/27/23.
//

import SwiftUI
struct PinImageSlider: View{
    var image: Image
    var imageList:[String] = ["lgWin","lgWin","rabbits"]
    var body: some View{
        image
            .resizable()
            .scaledToFill()
            .frame(width: UIScreen.current!.bounds.width)
            .overlay(content: {
//                ScrollView(.horizontal) {
//                    LazyHStack{
//                        ForEach(imageList.indices,id:\.self){ idx in
//                            listItem(title: imageList[idx])
//                        }
//                    }.scrollTargetLayout()
//                }.background(.background)
//                .scrollTargetBehavior(.viewAligned)
//                .scrollIndicators(.hidden)
                TabView {
                                            ForEach(imageList.indices,id:\.self){ idx in
                                                listItem(title: imageList[idx])
                                            }
                }.tabViewStyle(.page(indexDisplayMode: .always))
                                 .background(.background)
            })
    }
    func listItem(title:String)->some View{
        ZStack{
            Rectangle().fill(.ultraThinMaterial).background{
                Image(title).resizable()
            }
            Image(title).resizable()
                .scaledToFit()
                
        }.frame(width: UIScreen.current!.bounds.width)
    }
}
