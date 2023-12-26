//
//  BoardEditView.swift
//  lslpProject
//
//  Created by 김태윤 on 12/26/23.
//

import SwiftUI

struct BoardEditView:View {
    let width = UIScreen.current!.bounds.width / 3
    @State private var name = ""
    @State private var privateMode = false
    @State private var pickerPresent = false
    var defaultImage: Image? = Image(systemName: "plus")
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationView {
            ScrollView{
                VStack(spacing:24){
                    header
                    VStack(spacing:8){
                        itemView(name: "Board name") {
                            TextField("Enter the board name", text: $name)
                                .font(.system(.title3,weight: .semibold))
                                
                        }
                        Divider().padding(.bottom,4)
                        itemView(name: "작업") {
                            VStack(alignment:.leading, spacing:12) {
                                sectretView
                                deleteView
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
            .toolbar(.visible, for: .navigationBar)
            .toolbarTitleDisplayMode(.inline)
                .navigationTitle("보드 수정")
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Image(systemName: "xmark").wrapBtn {
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Text("Save").font(.headline).wrapBtn {
                            dismiss()
                        }
                    }
                }
        }
    }
    func itemView(name: String,view: @escaping ()->some View)-> some View{
        VStack(alignment:.leading,spacing:4){
            Text(name).font(.subheadline)
            view()
        }
    }
    @ViewBuilder var header: some View{
        VStack(alignment: .center,spacing: 16){
            EditImageView(isPresented:$pickerPresent,cropType: .circle(.init(width: 300, height: 300)), content: { state in
                switch state{
                case .empty:
                    if let defaultImage{
                        defaultImage.resizable().scaledToFit()
                    }else{
                        Image(systemName: "plus")
                            .font(.system(size: width * 0.66))
                    }
                case .failure(_ ): Image("plus").resizable().scaledToFill()
                case .loading(_): ProgressView()
                case .success(let img):
                    Image(uiImage: img).resizable(resizingMode: .stretch).scaledToFit()
                        .animToggler()
                        .onAppear(){
                            do{
//                                let imgData = try img.jpegData(maxMB: 1)
//                                vm.profile = imgData
//                                vm.updateImage = true
                            }catch{
                                print(error)
                            }
                        }
                }
            })
            .frame(width:  width,height: width)
            .background(.regularMaterial)
            .clipShape(Circle())
            Button(action: {
                pickerPresent = true
            }, label: {
                Text("Edit")
                    .font(.headline)
                    .padding(.vertical,4).padding(.horizontal,6)
            }).accent(background: .regularMaterial)
        }
    }
}
extension BoardEditView{
    var deleteView: some View{
        VStack(alignment:.leading,spacing: 4) {
            Text("보드 삭제").font(.system(.title3,weight: .semibold)).foregroundStyle(.red)
            Text("이 보드와 핀을 영구 삭제합니다. 이 작업은 취소할 수 없습니다!").font(.footnote).foregroundStyle(.secondary)
        }.wrapBtn {
            print("Hello world!!")
        }
    }
}

extension BoardEditView{
    var sectretView: some View{
        Toggle(isOn: $privateMode) {
            VStack(alignment:.leading) {
                Text("이 보드를 비밀 모드로 설정하기").font(.system(.title3,weight: .semibold))
                Text("회원님만 이 보드를 볼 수 있습니다.").font(.footnote).foregroundStyle(.secondary)   
            }
        }.padding(.trailing,4)
    }
}
