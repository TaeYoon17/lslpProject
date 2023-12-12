//
//  Comment.swift
//  lslpProject
//
//  Created by 김태윤 on 12/12/23.
//

import Foundation
struct Comment:Codable{
    var _id:String
    var content:String
    var time: String
    var creator:User?
}
