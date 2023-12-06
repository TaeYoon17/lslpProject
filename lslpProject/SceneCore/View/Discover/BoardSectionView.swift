//
//  PinnedSectionView.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/29.
//

import SwiftUI
struct BoardSectionView: View{
    @EnvironmentObject var discoverVM: DiscoverVM
    var board:Board
    var ratios: [CGFloat]
    init(board: Board){
        self.board = board
        self.ratios = board.pinnedImage.map{
            let size = UIImage(named: $0)?.size ?? .zero
            return size.height / size.width
        }
    }
    var body: some View{
        ScrollView {
            GeometryReader(content: { geometry in
                let gridItem = GridItem(.fixed(geometry.size.width / 2),spacing: 16)
                let columns = [gridItem,gridItem]
                LazyVGrid(columns: columns, spacing: 16,content: {
                    ForEach(board.pinnedImage.indices,id:\.self){ idx in
                        NavigationLink {
                            PinView(image: board.pinnedImage[idx])
                                .environmentObject(discoverVM)
                        } label: {
                            DiscoverItemView(image: board.pinnedImage[idx])
                                .frame(height: min(.greatestFiniteMagnitude, ratios[idx] * geometry.size.width / 2))
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                    }
                })
            })
        }.padding(.horizontal)
            .padding(.vertical,8)
            .toolbar(.hidden, for: .navigationBar)
    }
}
struct DiscoverItemView: View{
    
    let image:String
    var body: some View{
        Image(image,bundle: nil)
            .resizable()
            .scaledToFit()
    }
}

