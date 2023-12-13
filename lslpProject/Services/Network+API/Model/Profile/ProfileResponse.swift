//
//  ProfileResponse.swift
//  lslpProject
//
//  Created by 김태윤 on 12/12/23.
//

import Foundation
struct ProfileResponse:Codable,UserDetailProvider{
    var posts:[String]
    var followers:[User]
    var following:[User]
    var _id:String
    var email:String
    var nick:String?
    var phoneNum:String?
    var birthDay:String?
    var profile:String?
}
