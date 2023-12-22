//
//  BoardView.swift
//  lslpProject
//
//  Created by 김태윤 on 12/16/23.
//

import SwiftUI

struct BoardListView: View {
    @State private var height = 0
    @EnvironmentObject var vm: ProfileVM
    var body: some View {
        VStack{
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100, maximum: 300)),GridItem(.adaptive(minimum: 100, maximum: 300))], content: {
                ForEach(vm.boards.indices,id:\.self){ idx in
                    NavigationLink(value: vm.boards[idx]) {
                        BoardListItem(board: vm.boards[idx])
                    }.tint(.text)
                }
            })
            Spacer()
        }
    }
}
struct BoardListItem:View{
    var board: Board
//    var idx = 0
    var body: some View{
        VStack(alignment: .leading,spacing:4){
            Image("rabbits")
                .resizable()
                .scaledToFill()
                .frame(height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            VStack(alignment:.leading, spacing:0){
                Text(board.name).font(.headline)
                
                Text("\(board.pinnedImage.count) pins").font(.subheadline)
            }
        }
    }
}
#Preview {
    NavigationStack {
        BoardListView()
    }
}
