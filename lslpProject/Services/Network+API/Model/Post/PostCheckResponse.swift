//
//  PostCheckResponse.swift
//  lslpProject
//
//  Created by 김태윤 on 12/12/23.
//

import Foundation
struct PostCheckResponse:Codable{
    var data:[CheckData]
    var next_cursor:String
}
extension PostCheckResponse{
    struct CheckData:Codable{
        var likes:[String]
        var image:[String]
        var hashTags:[String]
        var comments:[Comment]
        var _id: String
        var creator:User
        var time: String
        var title:String?
        var content:String?
        var content1:String?
        var content2:String?
        var content3:String?
        var content4:String?
        var content5:String?
        var product_id:String?
    }
}
