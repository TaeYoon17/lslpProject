//
//  AllPinView.swift
//  lslpProject
//
//  Created by 김태윤 on 12/19/23.
//

import SwiftUI

struct AllPinView: View {
    @Binding var gridType: GridType
    let images = ["ARKit","AsyncSwift","Collections","lgWin","rabbits","macOS","Metal"]
    var body: some View {
        VStack{
            StaggredGrid(columns: gridType.gridColumns, list: images) { image in
                NavigationLink {
//                    PinView(image: image)
                    Image(image)
                } label: {
                    Image(image).resizable()
                        .aspectRatio(contentMode: .fit)
                        .background(.orange)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
            Spacer()
        }
    }
}

#Preview {
    AllPinView(gridType: .constant(.compact))
}
