//
//  ViewOptionItem.swift
//  lslpProject
//
//  Created by 김태윤 on 12/26/23.
//

import SwiftUI

struct ViewOptionItem:View{
    @Environment(\.dismiss) var dismiss
    let isSelected: Bool
    let name:String
    let action:()->Void
    var body: some View{
        Button(action: {
            dismiss()
            self.action()
        }, label: {
            HStack{
                Text(name)
                Spacer()
                if isSelected{
                    Image(systemName: "checkmark")
                }
            }.font(.title2.bold())
                .backgroundStyle(.gray)
        }).tint(.text)
    }
}
