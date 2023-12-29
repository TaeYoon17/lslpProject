//
//  ToolbarModifiers.swift
//  lslpProject
//
//  Created by 김태윤 on 12/29/23.
//

import SwiftUI
fileprivate struct KeyboardDismissModifier:ViewModifier{
    let action:()->Void
    func body(content: Content) -> some View {
        content.toolbar {
            ToolbarItem(placement: .keyboard) {
                HStack{
                    Spacer()
                    Button("Done"){ action() }.font(.headline).tint(.text)
                }
            }
        }
    }
}
extension View{
    func keyboardDismiss(action:@escaping ()->Void) -> some View{
        self.modifier(KeyboardDismissModifier(action: action))
    }
}
