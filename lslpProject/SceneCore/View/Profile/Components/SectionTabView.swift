//
//  AccountStore.swift
//  lslpProject
//
//  Created by 김태윤 on 12/6/23.
//

import SwiftUI
import Combine
struct SectionTabView<Data,Items: View,Header: View>: View where Data : RandomAccessCollection{
    @Binding var selectedIdx: Int
    @Binding var scrollHeight: CGFloat
    enum ScrollType{
        case pin
        case post
    }
    let data: Data
    
    let items : (Data) -> Items
    let headerView: (Binding<Int>,Data) -> Header
    let publisher: PassthroughSubject<ScrollType, Never> = PassthroughSubject()
    @Namespace var scrollType
    @State var myHeight: CGFloat = 0
    @State var myWidth: CGFloat = 0
    var body: some View{
            LazyVStack(spacing: 0, pinnedViews:[.sectionHeaders]){
                Section {
                TabView(selection: $selectedIdx,content:  {
                        items(data)
                        .background(GeometryReader { proxy in
                            Color.clear
                        })
                        .frame(maxWidth: .infinity)
                }).tabViewStyle(.page(indexDisplayMode: .never))
                .scrollDisabled(true)
                .frame(height: scrollHeight + 1)
                .padding(.top)
                }header: {
                        headerView($selectedIdx,data)
                }
            }
        .padding(.horizontal)
        
    }
}
