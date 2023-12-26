//
//  Create+Header.swift
//  lslpProject
//
//  Created by 김태윤 on 12/26/23.
//

import SwiftUI
//MARK: HEADER -- 이미지 썸네일을 넣을 수 있는 헤더
extension BoardCreateView{
    @ViewBuilder var header: some View{
        let size:CGSize = .init(width: 300, height: 200)
        VStack(alignment: .center,spacing: 16){
            EditImageView(isPresented:$pickerPresent,cropType: .rectangle(size), content: { state in
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
                    Image(uiImage: img).resizable(resizingMode: .stretch).scaledToFill()
                        .animToggler()
                        .onAppear(){
                            do{
                                let imgData = try img.jpegData(maxMB: 1)
                                vm.imageData = imgData
//                                vm.updateImage = true
                            }catch{
                                print(error)
                            }
                        }
                }
            })
            .frame(width:  width,height: width)
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 8 ))
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
