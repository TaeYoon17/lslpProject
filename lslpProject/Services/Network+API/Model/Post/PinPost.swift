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
    var board: String?
    var sendBoard: String?{
        get{ "_id_\(board ?? "")" }
        set{
            let h = newValue?.split(separator: "_").map{String($0)}[1]
            board = h
        }
    }
    var get:Post{
        Post(title: title,product_id: productId,content: content,file: imageDatas,content1: link,content2: board)
    }
}
