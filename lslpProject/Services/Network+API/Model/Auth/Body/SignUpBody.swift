//
//  SignUpBody.swift
//  lslpProject
//
//  Created by 김태윤 on 12/12/23.
//

import Foundation
protocol SignUpBodyAble{
    var email: String {get set}
    var password: String {get set}
    var nick : String {get set}
    var phoneNum: String? {get set}
    var birthDay: String? {get set}
}
