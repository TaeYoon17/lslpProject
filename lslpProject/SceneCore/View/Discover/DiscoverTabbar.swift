//
//  DiscoverTabbar.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/29.
//

import Foundation
import SwiftUI
struct DiscoverTabbar: View {
    var tabbarItems: [String]
    @Binding var selected: Int
    @State private var selectedIndex = 0
    @Namespace private var menuItemTransition
    
    var body: some View {
        ScrollViewReader { scrollView in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8){
                    ForEach(tabbarItems.indices, id: \.self) { index in
                        DiscoverTabbarItem(name: tabbarItems[index],isActive: index == selectedIndex ,namespace: menuItemTransition)
                            .onTapGesture { withAnimation(.easeInOut) {
                                    selected = index
                                }
                        }
                    }
                }
            }
            .padding(.horizontal)
            .onChange(of: selectedIndex) { index in
                withAnimation {
                    scrollView.scrollTo(index, anchor: .center)
                }
            }
        }.onChange(of:selected,perform:{ val in
            withAnimation(.easeInOut){
                selectedIndex = val
            }
        })
        
    }
}
struct DiscoverTabbarItem: View {
    var name: String
    var isActive: Bool = false
    let namespace: Namespace.ID
    var body: some View {
        Text(name).font(.headline)
            .padding(.vertical,8)
            .foregroundStyle(.text)
            .overlay(alignment: .bottom) {
                if isActive{
                    Capsule().foregroundStyle(.text).frame(height: 4)
                        .matchedGeometryEffect(id: "highlightmenuitem", in: namespace)
                }
            }
    }
}
