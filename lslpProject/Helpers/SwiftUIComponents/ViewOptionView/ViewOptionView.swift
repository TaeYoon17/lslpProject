//
//  ViewOptionView.swift
//  lslpProject
//
//  Created by 김태윤 on 12/25/23.
//

import SwiftUI

struct ViewOptionView<T: View>:View {
    @Environment(\.dismiss) var dismiss
    @State private var presentHeight: CGFloat = 0
    let view: ()->T
    init(_ view:@escaping ()->T){
        self.view = view
    }
    var body: some View {
        VStack(spacing: 16){
            view()
            Button(action: {
                dismiss()
            }, label: {
                Text("Close").padding().background(.regularMaterial)
                    .clipShape(Capsule()).font(.title3).fontWeight(.semibold)
            }).tint(.text)
        }.padding(.horizontal)
        .background(GeometryReader{ proxy in
            Color.clear.onAppear(){
                presentHeight = proxy.size.height
            }
        })
        .presentationDetents([.height(presentHeight + 44)])
        .presentationCornerRadius(16)
    }
}
