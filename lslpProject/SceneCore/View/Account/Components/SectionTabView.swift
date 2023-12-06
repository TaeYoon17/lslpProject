//
//  AccountStore.swift
//  lslpProject
//
//  Created by 김태윤 on 12/6/23.
//

import SwiftUI
struct SectionTabView<Data,Items: View,Header: View>: View where Data : RandomAccessCollection{
    @Binding var selectedIdx: Int
    let data: Data
    let height: CGFloat
    let items : (Data) -> Items
    let headerView: (Binding<Int>,Data) -> Header
    var body: some View{
        LazyVStack(pinnedViews:[.sectionHeaders]){
            Section {
                TabView(selection: $selectedIdx,
                        content:  {
                    items(data)
                }).tabViewStyle(.page(indexDisplayMode: .never))
                    .frame(height: height)
            } header: {
                headerView($selectedIdx,data)
                    .padding(.vertical,4)
            }.padding(.horizontal)
        }
    }
}
