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
            let ratio = size.height / size.width
            print(ratio)
            return ratio
        }
    }
    var body: some View{
        ScrollView {
            GeometryReader(content: { geometry in
//                let gridItem = GridItem(.adaptive(minimum: geometry.size.width / 2
//                                                  , maximum: geometry.size.width / 2),spacing: 16)
                let gridItem = GridItem(.fixed(geometry.size.width / 2),spacing: 16)
                let columns = [gridItem,gridItem]
                LazyVGrid(columns: columns, spacing: 16,content: {
                    ForEach(board.pinnedImage.indices,id:\.self){ idx in
                        Image(board.pinnedImage[idx], bundle: nil)
                            .resizable()
                            .scaledToFit()
                            .frame(height: ratios[idx] * geometry.size.width / 2)
                            .clipShape(RoundedRectangle(cornerRadius: 16))                    }
                })
            })
        }.padding(.horizontal)
        .padding(.vertical,8)
    }
}
