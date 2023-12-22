//
//  AddCommentView.swift
//  lslpProject
//
//  Created by 김태윤 on 12/20/23.
//

import SwiftUI

struct AddCommentView: View {
    @Environment(\.dismiss) var dismiss
    @State var text = "sadf"
    var body: some View {
        NavigationStack {
            TextEditor(text: $text)
                .toolbarTitleDisplayMode(.inline)
                .toolbar(.visible, for: .navigationBar)
                .navigationTitle("Add Comment")
                .toolbar(content: {
                    ToolbarItem(placement: .cancellationAction) {
                        Image(systemName: "xmark")
                            .wrapBtn {
                                dismiss()
                            }
                    }
                    ToolbarItemGroup(placement: .keyboard) {
                        HStack{
                            Spacer()
                            Text("\(text.count)/500").foregroundStyle(.secondary)
                            Button{
                                print("댓글 포스트")
                            }label:{
                                Text("Post")
                                    .font(.title3.bold())
                                    .padding(12)
                                    .background(.green)
                                    .clipShape(Capsule())
                            }.tint(.white)
                        }
                    }
            })
            .background(.background)
        }
        .background(.background)
        .presentationDetents([.medium,.large])
            
            
    }
}

#Preview {
    AddCommentView()
}
