//
//  DiscoverTabbar.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/29.
//

import Foundation
import SwiftUI
struct TopTabbar: View {
    var tabbarItems: [String]
    @Binding var selected: Int
    @State private var selectedIndex = 0
    @Namespace private var menuItemTransition
    var body: some View {
        ScrollViewReader { scrollView in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8){
                    ForEach(tabbarItems.indices, id: \.self) { index in
                        TopTabbarItem(name: tabbarItems[index],isActive: index == selectedIndex ,namespace: menuItemTransition)
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
struct TopTabbarItem: View {
    var name: String
    var isActive: Bool = false
    let namespace: Namespace.ID
    let font: Font
    let paddingHeight:CGFloat
    let lineHeight: CGFloat
    init(name: String, isActive: Bool, namespace: Namespace.ID, font: Font = .headline, paddingHeight: CGFloat = 8, lineHeight: CGFloat = 4) {
        self.name = name
        self.isActive = isActive
        self.namespace = namespace
        self.font = font
        self.paddingHeight = paddingHeight
        self.lineHeight = lineHeight
    }
    var body: some View {
        Text(name)
            .font(font)
            .padding(.vertical,paddingHeight)
            .foregroundStyle(.text)
            .overlay(alignment: .bottom) {
                if isActive{
                    Capsule().foregroundStyle(.text).frame(height: lineHeight)
                        .matchedGeometryEffect(id: "highlightmenuitem", in: namespace)
                }
            }
    }
}
