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

