//
//  BoardView.swift
//  lslpProject
//
//  Created by 김태윤 on 12/22/23.
//

import SwiftUI
import RxSwift
struct BoardView: View {
    @Environment(\.dismiss) var dismiss
    var board: Board
    var body: some View {
        ScrollView{
            header
            .navigationBarBackButtonHidden()
            .toolbar(.hidden, for: .tabBar)
            .toolbar{
                ToolbarItem(placement: .topBarLeading) {
                    Image(systemName: "chevron.left").fontWeight(.semibold).wrapBtn { dismiss() }
                }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Image(systemName: "slider.horizontal.3").fontWeight(.semibold).wrapBtn {
                        print("Hello world")
                    }
                }
            }
        }.overlay(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            Button(action: {
                print("appendItem")
            }, label: {
                Image(systemName: "plus").font(.title2.bold())
                    .padding(.all)
                    .foregroundStyle(.text)
                    .background(.reverse)
                    .clipShape(Circle())
                    .shadow(radius: 1)
            })
        }
        .hideTabbar()
    }
}

extension BoardView{
    var header: some View{
        VStack(alignment:.center,spacing: 16){
            Text(board.name).font(.largeTitle.bold())
            HStack(alignment:.center,spacing:16){
                headerButton(text: "More Ideas", icon: "wand.and.stars.inverse") {
                    print("more")
                }
                headerButton(text: "Organize", icon: "square.filled.on.square") {
                    print("Organize")
                }
            }
        }
    }
    func headerButton(text:String,icon:String,action:@escaping ()-> Void) -> some View{
        Button{ action() }label: {
            VStack(alignment:.center){
                RoundedRectangle(cornerRadius: 16).fill(Material.ultraThickMaterial)
                    .frame(width: 88, height: 88, alignment: .center)
                    .overlay(alignment: .center) {
                        Image(systemName:icon )
                            .font(.title2)
                            .bold()
                    }
                Text(text).font(.subheadline)
            }
        }.tint(.text)
    }
}
