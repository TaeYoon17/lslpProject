//
//  FollowResponse.swift
//  lslpProject
//
//  Created by 김태윤 on 12/12/23.
//

import Foundation
struct FollowResponse:Codable{
    var user:String
    var following:String
    var following_status:Bool
}
