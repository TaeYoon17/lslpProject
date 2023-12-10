//
//  Post.swift
//  lslpProject
//
//  Created by 김태윤 on 12/9/23.
//

import Foundation
import Alamofire
struct Post:Codable{
    var title: String?
    var product_id:String?
    var content: String?
    var file:[Data]?
    var content1:String?
    var content2:String?
    var content3:String?
    var content4:String?
    var content5:String?
//    var getPost:Parameters{
//        var p = Parameters()
//        if let title{ p["title"] = title }
//        if let product_id {p["product_id"] = product_id}
//        if let
//        return p
//    }
}
