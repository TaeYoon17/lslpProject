//
//  BoardWriteC+Modifier.swift
//  lslpProject
//
//  Created by 김태윤 on 12/27/23.
//

import SwiftUI
extension BoardWriteC{
    struct AddModi: ViewModifier{
        func body(content: Content) -> some View {
            content.font(.subheadline).fontWeight(.semibold)
                .foregroundStyle(.white)
                .padding(.vertical,6)
                .padding(.horizontal,10)
                .background(Capsule().fill(Color.green))
                .contentShape(Capsule())
        }
    }
    struct ToolbarModi: ViewModifier{
        let title:String
        @Binding var isAble: Bool
        let leftAction:()->Void
        let rightAction:()->Void
        let keyboardAction:()->Void
        func body(content: Content) -> some View {
            content.interactiveDismissDisabled() // 스와이프로 dismiss 막는 모디파이어
                .scrollIndicators(.hidden)
                .padding(.horizontal)
                .toolbar(.visible, for: .navigationBar)
                .toolbarTitleDisplayMode(.inline)
                .navigationTitle(title)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Image(systemName: "xmark").wrapBtn {
                            leftAction()
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Text("Done").font(.headline).wrapBtn {
                            rightAction()
                        }.disabled(!isAble)
                        .opacity(!isAble ? 0.6 : 1)
                    }
                }.keyboardDismiss {
                    keyboardAction()
                }
        }
    }
}

