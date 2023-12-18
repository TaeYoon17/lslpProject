//
//  BoardView.swift
//  lslpProject
//
//  Created by 김태윤 on 12/16/23.
//

import SwiftUI

struct BoardView: View {
    //    @ObservableObject var vm: ProfileVM
    //    @ObservableObject var vm: ProfileVM
    //    @State private var scrollDisable: Bool = true
    @State private var height = 0
    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100, maximum: 300)),GridItem(.adaptive(minimum: 100, maximum: 300))], content: {
            ForEach((0...40),id:\.self) { val in
                BoardListItem(idx: val)
            }
        })
        
    }
}
struct BoardListItem:View{
    var idx = 0
    var body: some View{
        VStack(alignment: .leading,spacing:4){
            Image("rabbits")
                .resizable()
                .scaledToFill()
                .frame(height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            VStack(alignment:.leading, spacing:0){
                Text("Placeholder").font(.headline)
                Text("\(idx) pins").font(.subheadline)
            }
        }
    }
}
#Preview {
    NavigationStack {
        BoardView()
    }
}
