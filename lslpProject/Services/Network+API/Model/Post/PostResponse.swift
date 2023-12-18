//
//  PostResponse.swift
//  lslpProject
//
//  Created by 김태윤 on 12/12/23.
//

import Foundation

// 포스트 요청 응답
struct PostResponse:Codable{
    // 포스트에 좋아요한 유저들의 유저 id 배열
    var likes:[String]
    var image:[String]
    var hashTags:[String]
    var comments:[Comment]
    var _id:String
    var creater:User
    var time:String
    var title:String?
    var content:String?
    var product_id: String?
    
}

//{"data":[{"likes":[],"image":[],"hashTags":[],"comments":[],"_id":"6574a979c91bb39798f0f1c1","creator":{"_id":"655f3f6cc2c219175f83825b","nick":"휴주머니Flexing","profile":"uploads/profiles/1702712363107.jpg"},"time":"2023-12-09T17:52:57.551Z","title":"Aespa","content":"N","product_id":"Board"},{"likes":[],"image":[],"hashTags":[],"comments":[],"_id":"65749681c91bb39798f0f1aa","creator":{"_id":"655f3f6cc2c219175f83825b","nick":"휴주머니Flexing","profile":"uploads/profiles/1702712363107.jpg"},"time":"2023-12-09T16:32:01.263Z","title":"Aespa","content":"N","product_id":"Board"}],"next_cursor":"0"
//}
