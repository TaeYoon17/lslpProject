//
//  ProfileEditBody.swift
//  lslpProject
//
//  Created by 김태윤 on 12/12/23.
//

import Foundation
struct ProfileEditBody:Codable{
    var nick:String?
    var phoneNum:String?
    var birthDay:String?
    // 계정 프로필 이미지
    var profile:Data?
}
