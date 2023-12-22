//
//  TabbarModifiers.swift
//  lslpProject
//
//  Created by 김태윤 on 12/22/23.
//

import SwiftUI
import RxSwift


struct HideTabbar:ViewModifier{
    func body(content: Content) -> some View {
        content.onAppear() {
            App.Manager.shared.hideTabbar.onNext(true)
        }.onDisappear(){
            App.Manager.shared.hideTabbar.onNext(false)
        }
    }
}
extension View{
    func hideTabbar() -> some View{
        self.modifier(HideTabbar())
    }
}
