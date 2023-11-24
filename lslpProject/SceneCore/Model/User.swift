//
//  User.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/14.
//

import Foundation

struct User:Codable{
    let email: String
    let password: String
    let nick : String
    let phoneNum: String?
    let birthDay: String?
    init(email: String, password: String, nick: String, phoneNum: String? = nil, birthDay: String? = nil) {
        self.email = email
        self.password = password
        self.nick = nick
        self.phoneNum = phoneNum
        self.birthDay = birthDay
    }
}
