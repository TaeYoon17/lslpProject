//
//  User.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/14.
//

import Foundation
struct UserDetail:Codable{
    var email: String
    var password: String
    var nick : String
    var phoneNum: String?
    var birthDay: String?
    init(email: String, password: String, nick: String, phoneNum: String? = nil, birthDay: String? = nil) {
        self.email = email
        self.password = password
        self.nick = nick
        self.phoneNum = phoneNum
        self.birthDay = birthDay
    }
}
