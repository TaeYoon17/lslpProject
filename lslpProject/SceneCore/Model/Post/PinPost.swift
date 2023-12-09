//
//  Post.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/23.
//

import Foundation
import UIKit
protocol PinPostable:Codable{
    var productId:String {get set}
    var title: String {get set}
    var imageDatas:[Data] {get set}
    var content: String? {get set}
    var link:String? {get set}
    var sendBoard: String? {get set}
}
struct PinPostUpload:Codable,PinPostable{
    var productId:String = "Pin_\(UUID().uuidString)"
    var title: String
    var imageDatas:[Data]
    var content: String?
    var link:String?
    var sendBoard: String?
    //MARK: -- 임시 수정
    enum CodingKeys: String,CodingKey{
        case productId = "product_id"
        case title = "title"
        case content = "content"
        case link = "content1"
        case imageDatas = "imageDatas"
        case sendBoard = "content2"
    }
    init(pinPostable: PinPostable) throws {
        let data = try JSONEncoder().encode(pinPostable)
        let pinpost = try JSONDecoder().decode(PinPostUpload.self, from: data)
        self = pinpost
    }
}

struct PinPost:PinPostable{
    var productId: String = "Pin_\(UUID().uuidString)"
    var title: String = ""
    var content: String?
    var link: String?
    var imageDatas: [Data] = []
    var board: String?
    var upload: PinPostUpload?{
        try? PinPostUpload(pinPostable: self)
    }
    var sendBoard: String?{
        get{ "_id_\(board ?? "")" }
        set{
            let h = newValue?.split(separator: "_").map{String($0)}[1]
            board = h
        }
    }
}
//struct PostUpload{
//    var title: String?
//    var content: String?
//    var imageDatas:[Data]
//    var productId:String {
//        UUID().uuidString
//    }
//}
