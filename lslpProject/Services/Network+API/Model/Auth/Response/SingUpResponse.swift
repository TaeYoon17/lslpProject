//
//  SingUpResponse.swift
//  lslpProject
//
//  Created by 김태윤 on 12/12/23.
//

import Foundation
struct SignUpResponse:Codable{
    let _id: String
    let email:String
    let nick: String
    enum CodingKeys: String, CodingKey {
        case _id = "_id",email = "email",nick = "nick"
    }
}
