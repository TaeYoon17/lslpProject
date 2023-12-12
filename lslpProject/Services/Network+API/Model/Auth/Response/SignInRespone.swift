//
//  SignInRespone.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/25.
//

import Foundation
struct SignInRespone:Codable{
    let _id: String
    let accessToken: String
    let refreshToken: String
    enum CodingKeys: String,CodingKey{
        case accessToken = "token"
        case refreshToken = "refreshToken"
        case _id
    }
}
