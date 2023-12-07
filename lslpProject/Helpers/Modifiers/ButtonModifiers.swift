//
//  ButtonModifiers.swift
//  lslpProject
//
//  Created by 김태윤 on 12/6/23.
//

import SwiftUI
private struct ButtonWrapper: ViewModifier{
    let action: ()->Void
    func body(content: Content) -> some View {
        Button(action:action,label:{content})
            .buttonStyle(.plain)
    }
}
extension View{
    func wrapBtn(action: @escaping ()->Void) -> some View{
        modifier(ButtonWrapper(action: action))
    }
}
private struct AccentButton:ButtonStyle{
    let shapeStyle:AnyShapeStyle
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical,8).padding(.horizontal,8).background(shapeStyle).clipShape(Capsule()).tint(.text)
    }
}
extension Button{
    func accent<S>(background:S)-> some View where S : ShapeStyle{
        self.buttonStyle(AccentButton(shapeStyle: AnyShapeStyle(background)))
    }
}

