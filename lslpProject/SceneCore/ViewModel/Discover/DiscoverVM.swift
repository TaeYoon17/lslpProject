//
//  DiscoverVM.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/29.
//

import Foundation
class DiscoverVM: ObservableObject{
    @Published var boardItems:[DiscoverItem] = [.init(name: "Computing",pinnedImage:  ["ARKit","AsyncSwift","C++","macOS","Metal"]),
                                         .init(name: "iDol",pinnedImage: ["picture_demo"])]
    deinit{
        print("DiscoverVM은 걱정 말라구~")
    }
}
struct DiscoverItem{
    let name:String
    let pinnedImage:[String]
}
