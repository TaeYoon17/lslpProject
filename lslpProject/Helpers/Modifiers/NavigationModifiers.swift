//
//  NavigationModifiers.swift
//  lslpProject
//
//  Created by 김태윤 on 12/7/23.
//


import SwiftUI
private struct NavigationLinkWrapper: ViewModifier{
    let value: any Hashable
    func body(content: Content) -> some View {
        ZStack{
            NavigationLink(value: value) {
                EmptyView()
            }.opacity(0)
            content
        }
    }
}
extension NavItem{
    func wrapLink(value: any Hashable)-> some View{
        self.modifier(NavigationLinkWrapper(value: value))
    }
}
