//
//  BoardWriteC.swift
//  lslpProject
//
//  Created by 김태윤 on 12/27/23.
//

import SwiftUI
enum BoardWriteC{
    static func itemView(name: String,view: @escaping ()->some View)-> some View{
        VStack(alignment:.leading,spacing:4){
            Text(name).font(.subheadline)
            view().tint(.text)
        }
    }
    struct Name:View{
        @Binding var name:String
        var focused:FocusState<Bool>.Binding
        var body: some View{
            itemView(name: "Board name") {
                TextField("Enter the board name", text: $name).focused(focused)
                    .font(.system(.title3,weight: .semibold))
            }
        }
    }
    struct Secret:View{
        @Binding var isPrivacy:Bool
        var body: some View{
            itemView(name: "작업") {
                Toggle(isOn: $isPrivacy) {
                    VStack(alignment:.leading) {
                        Text("이 보드를 비밀 모드로 설정하기").font(.system(.title3,weight: .semibold))
                        Text("회원님만 이 보드를 볼 수 있습니다.").font(.footnote).foregroundStyle(.secondary)
                        
                    }
                }.padding(.trailing,4)
            }
        }
    }
    struct HashTag:View{
        @Binding var tags:[Tag]
        @Binding var tagName:String
        var focused:FocusState<Bool>.Binding
        var body: some View{
            itemView(name: "Hash tags: \(tags.count) / 5") {
                Group{
                    if !tags.isEmpty{ TagView(tags: $tags).background(.green) }
                    HStack(spacing:4){
                        Text("#")
                        TextField("Enter hash tags", text: $tagName).focused(focused)
                        Button{
                            guard !tagName.isEmpty else {return}
                            tags.append(Tag(text: tagName))
                            tagName = ""
                        }label: {
                            Text("Add").modifier(BoardWriteC.AddModi())
                        }.disabled(tagName.isEmpty)
                        .opacity(tagName.isEmpty ? 0.6 : 1)
                        .animation(.easeInOut, value: tagName.isEmpty)
                    }.font(.system(.title3,weight: .semibold))
                        .opacity(tags.count >= 5 ? 0.6 : 1)
                        .disabled(tags.count >= 5)
                }
            }
        }
    }
    struct Delete:View{
        let action:()->Void
        var body: some View{
            itemView(name: "작업") {
                HStack{
                    VStack(alignment:.leading,spacing: 4) {
                        Text("보드 삭제").font(.system(.title3,weight: .semibold)).foregroundStyle(.red)
                        Text("이 보드와 핀을 영구 삭제합니다. 이 작업은 취소할 수 없습니다!").font(.footnote).foregroundStyle(.secondary)
                    }.wrapBtn {
                        action()
                    }
                    Spacer()
                }.frame(maxWidth: .infinity)
            }
        }
    }
}
