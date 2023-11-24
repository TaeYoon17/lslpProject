//
//  SignInRespone.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/25.
//

import Foundation
struct SignInRespone:Codable{
    let accessToken: String
    let refreshToken: String
    enum CodingKeys: String,CodingKey{
        case accessToken = "token"
        case refreshToken = "refreshToken"
    }
}
//{
//"token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9",
//"refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9" }
