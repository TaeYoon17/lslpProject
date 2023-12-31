//
//  PinFactory.swift
//  lslpProject
//
//  Created by 김태윤 on 12/31/23.
//

import SwiftUI
enum PinFactory{
    struct ProfileBanner: View{
        @State private var isFollow = false
        let profileAction: ()->Void
        var body:some View{
            HStack {
                Button{
                    profileAction()
                }label:{
                    Image("lgWin")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 48,height: 48,alignment:.leading)
                        .padding(.all,4)
                        .background(.white)
                        .clipShape(Circle())
                }
                VStack(alignment:.leading){
                    Text("Afnan").font(.headline)
                    Text("200 followers").font(.subheadline)
                }
                Spacer()
                Button {
                    isFollow.toggle()
                } label: {
                    Text("Follow")
                        .font(.headline.weight(.medium))
                        .padding(12).background( .regularMaterial).clipShape(Capsule())
                }.tint(.text)
            }
        }
    }
    struct BannerBottom:View{
        var link: String = ""
        let saveAction: ()->Void
        let heartAction: ()-> Void
        let shareAction: ()->Void
        var body: some View{
            HStack{
                Image(systemName: "heart.square.fill")
                    .font(.system(size: 28))
                    .wrapBtn {
                    heartAction()
                    print("heartAction")
                }
                Spacer()
                HStack(alignment:.center){
                    if !link.isEmpty,let url = URL(string: link ) {
                        Link(destination: url) {
                            Text("Visit")
                                .font(.title3.weight(.semibold))
                                .padding(.all,12)
                                .padding(.horizontal,4)
                                .background(.regularMaterial)
                                .clipShape(Capsule())
                        }.tint(.text)
                    }
                    Button(action: {
                        saveAction()
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
                    shareAction()
                    print("shareAction")
                }
            }
        }
    }
}
//MARK: -- 모디파이어 설정
extension PinFactory{
    struct NavigationModifier: ViewModifier{
        let leftAction:()->Void
        let rightAction:()->Void
        func body(content: Content) -> some View {
            content.navigationBarTitleDisplayMode(.inline)
                .toolbar(.visible, for: .navigationBar)
                .toolbarBackground(.hidden, for: .navigationBar)
                .navigationBarBackButtonHidden()
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            leftAction()
                        } label: {
                            Image(systemName: "chevron.left")
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            print("More...")
                            rightAction()
                        } label: {
                            Image(systemName: "ellipsis")
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                        }
                    }
                }
        }
    }
}
