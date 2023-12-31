//
//  PinImageSlider.swift
//  lslpProject
//
//  Created by 김태윤 on 12/27/23.
//

import SwiftUI
struct PinImageSlider: View{
    var image: Image
    var imageList:[Data]
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
                        ListItem(imageData: imageList[idx])
                    }
                }.tabViewStyle(.page(indexDisplayMode: .always))
                    .background(.background)
            })
    }
    struct ListItem:View{
        let imageData:Data
        let width = UIScreen.current!.bounds.width
        @State private var image: Image = Image(systemName: "heart")
        var body:some View{
            ZStack{
                Rectangle().fill(.ultraThinMaterial).background{
                    image.resizable()
                }
                image.resizable()
                    .scaledToFit()
                
            }.frame(width: width)
                .task {
                    let uiImage = UIImage.fetchBy(data: imageData,size: .init(width: width, height: width))
                    self.image = Image(uiImage: uiImage)
                }
        }
    }
}
