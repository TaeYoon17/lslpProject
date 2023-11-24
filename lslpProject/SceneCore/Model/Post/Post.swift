//
//  Post.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/23.
//

import Foundation
struct PostUpload{
    var title: String?
    var content: String?
    var imageDatas:[Data]
    var productId:String {
        UUID().uuidString
    }
}
