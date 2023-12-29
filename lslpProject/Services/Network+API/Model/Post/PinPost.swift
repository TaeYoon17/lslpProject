//
//  Post.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/23.
//

import Foundation
import UIKit
struct PinPost:Codable{
    var productId: String = "Pin"
    var title: String = ""
    var content: String?
    var link: String?
    var imageDatas: [Data] = []
    var board: String = ""
    var hashTags: String = ""
    var get:Post{
        let post = Post(title: title,product_id: productId,content: hashTags,file: imageDatas,content1: content,content2: link,content3: board)
        print("get Post")
        print(post)
        return post
    }
}
