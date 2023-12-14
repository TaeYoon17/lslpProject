//
//  Board.swift
//  lslpProject
//
//  Created by 김태윤 on 12/9/23.
//

import Foundation
struct Board:Identifiable,Hashable{
    var id = UUID()
    var productId: String = "Board"
    
    var name: String = ""
    // 일단 이미지들의 문자열을 갖도록 하자
    var pinnedImage: [String] = []
    var isPrivacy: Bool = false
//    var get: Post{
//        var post = Post()
//        post.content
//    }
}
struct BoardPost:Codable{
    var productId: String = "Board"
    var name:String = ""
    var isPrivacy: Bool = false
    var get: Post{
        Post(title: name,product_id: productId,content: isPrivacy ? "Y":"N")
    }
}