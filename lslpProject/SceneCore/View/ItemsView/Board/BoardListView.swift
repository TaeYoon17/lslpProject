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
            let grids = [GridItem(.flexible(), spacing: nil, alignment: nil),
                         GridItem(.flexible(), spacing: nil, alignment: nil)]
            LazyVGrid(columns: grids, content: {
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
    let board: Board
    //    var idx = 0
    @State private var image: UIImage?
    var body: some View{
        VStack(spacing:4){
            if let image{
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }else{
                Image("rabbits").resizable()
                    .scaledToFill()
                    .frame(height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            HStack{
                VStack(alignment:.leading, spacing:0){
                    Text(board.name).font(.headline)
                    Text("\(board.pinCounts) pins").font(.subheadline)
                }.padding(.leading,4)
                Spacer()
            }
        }.frame(maxWidth:.infinity)
            .task {
                if let imageData = board.data{
                    await MainActor.run {
                        withAnimation {
                            self.image = UIImage(data: imageData)
                        }
                    }
                }
            }
    }
}
#Preview {
    NavigationStack {
        BoardListView()
    }
}
