//
//  PinView.swift
//  lslpProject
//
//  Created by 김태윤 on 12/6/23.
//

import Foundation
import SwiftUI
extension PinView{
    enum PinViewPresent:String,Identifiable{
        var id:String{ UUID().uuidString }
        case more
        case addComment
    }
}
struct PinView: View{
    @DefaultsState(\.navigationBarHeight) var naviHeight
    @Environment(\.dismiss) var dismiss
    @State var presentType: PinViewPresent? = nil
    var pin:Pin
    @Binding var image: Image?
    var body: some View{
        ScrollView{
            VStack{
                PinImageSlider(image: image ?? Image(systemName: "heart"),imageList: pin.images)
                    .overlay(alignment:.top){
                        Rectangle()
                            .fill(Gradient(colors: [.black.opacity(0.2),.clear]))
                            .frame(height:naviHeight + 44)
                    }
                Group{
                    PinFactory.ProfileBanner {
                        print("프로필 탭")
                    }
                    PinFactory.BannerBottom {
                     print("Hello world")
                    } heartAction: {
                        print("Heart")
                    } shareAction: {
                        print("Share")
                    }
                }.padding(.horizontal,16)
            }
            Divider().padding(.vertical,4)
            comments
            Divider().padding(.vertical,4)
        }
        .offset(y: -naviHeight)
        .modifier(PinFactory.NavigationModifier(leftAction: {
            dismiss()
        }, rightAction: {
            print("More Action!!")
        }))
        .sheet(item: $presentType) { type in
            switch type{
            case .more: AddCommentView()
            case .addComment: AddCommentView()
            }
        }
    }
}
extension PinView{
    
}
extension PinView{
    var comments: some View{
        Section {
            Button{
                presentType = .addComment
            }label: {
                HStack{
                    Text("Add the first comment")
                    Spacer()
                }.padding(.vertical,8)
                    .padding(.horizontal)
                    .overlay(content: {
                        Capsule().stroke(.secondary,lineWidth:2)
                    })
                    .padding(.horizontal,20)
                    .padding(.top,8)
                    .padding(.bottom)
            }.tint(.text)
        } header: {
            HStack(alignment: .center){
                Text("What do you think?")
                Spacer()
                HStack(spacing:4){
                    Text("8")
                    Image(systemName: "heart")
                        
                }.font(.system(size: 18,weight:.semibold))
                .wrapBtn {
                        print("My Like!!")
                    }
            }.padding(.horizontal).padding(.top)
                .font(.headline)
        }
    }
}
