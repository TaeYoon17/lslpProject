//
//  DiscoverVM.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/29.
//

import Foundation
class DiscoverVM: ObservableObject{
    @Published var boardItems:[Board] = [.init(name: "Computing",pinnedImage:  ["ARKit","AsyncSwift","C++","macOS","Metal"]),
                                         .init(name: "iDol",pinnedImage: ["picture_demo"])]
}
struct Board{
    let name: String
    // 일단 이미지들의 문자열을 갖도록 하자
    let pinnedImage: [String]
}
