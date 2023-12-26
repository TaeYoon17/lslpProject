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
    var hashTags: [String] = [] // 이거 변형시켜야함
    var data:Data?
    static func getBy(checkData data:PostCheckResponse.CheckData) async ->Board{
        var board = Board()
        board.id = data._id
        board.name = data.title ?? ""
        board.pinnedImage = []
        board.isPrivacy = (data.content ?? "N") == "Y" ? true : false
        if let content1 = data.content1{
            board.hashTags = content1.split(separator: "-").map{String($0)}
        }
        if let imagePath = data.image.first{
            board.data = try? await NetworkService.shared.getImageData(imagePath: imagePath)
        }
        return board
    }
}
struct BoardPost:Codable{
    var productId: String = "Board"
    var name:String = ""
    var isPrivacy: Bool = false
    var hashTags: String = ""
    var data:Data?
    var get: Post{
        var post = Post(title: name,product_id: productId,content: isPrivacy ? "Y":"N",content1: hashTags)
        if let data{
            post.file = [data]
        }
        return post
    }
}
