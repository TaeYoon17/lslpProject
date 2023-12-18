//
//  Board.swift
//  lslpProject
//
//  Created by 김태윤 on 12/9/23.
//

import Foundation
struct Board:Identifiable,Hashable{
    var id:String = UUID().uuidString
    var productId: String = "Board"
    
    var name: String = ""
    // 일단 이미지들의 문자열을 갖도록 하자
    var pinnedImage: [String] = []
    var isPrivacy: Bool = false
    
    static func getBy(checkData data:PostCheckResponse.CheckData)->Board{
        var board = Board()
        board.id = data._id
        board.name = data.title ?? ""
        board.pinnedImage = []
        board.isPrivacy = (data.content ?? "N") == "Y" ? true : false
        return board
    }
}
struct BoardPost:Codable{
    var productId: String = "Board"
    var name:String = ""
    var isPrivacy: Bool = false
    var get: Post{
        Post(title: name,product_id: productId,content: isPrivacy ? "Y":"N")
    }
}
