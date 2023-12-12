//
//  PresentModifier.swift
//  lslpProject
//
//  Created by 김태윤 on 12/12/23.
//

import SwiftUI
extension ProfileView{
    enum SheetType:String, Identifiable{
        var id: String{ self.rawValue}
        case profile
    }
    enum FullscreenType:String, Identifiable{
        var id: String{ self.rawValue}
        case settings
    }
    enum PresentType:Equatable{
        case sheet(SheetType)
        case fullscreen(FullscreenType)
    }
    
    
    struct SheetModifier<A: View,B:View>: ViewModifier{
        @Binding var presentType:PresentType?
        @ViewBuilder var sheet:((SheetType) -> A)
        @ViewBuilder var fullScreen:((FullscreenType) -> B)
        @State private var fullScreenType: ProfileView.FullscreenType? = nil
        @State private var sheetType: SheetType? = nil
        func body(content: Content) -> some View {
            content
                .sheet(item: $sheetType, content:sheet)
                .fullScreenCover(item: $fullScreenType,content: fullScreen)
                .onChange(of: presentType, perform: { value in
                    switch value{
                    case .fullscreen(let fullScreen):
                        self.fullScreenType = fullScreen
                        self.sheetType = nil
                    case .sheet(let sheet):
                        self.sheetType = sheet
                        self.fullScreenType = nil
                    case .none: break
                    }
                    self.presentType = nil
                })
        }
    }
    
}
