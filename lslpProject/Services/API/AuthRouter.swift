//
//  AuthRouter.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/14.
//

import Foundation
import Alamofire
enum AuthRouter:URLRequestConvertible{
//    case signUp(),signIn()
    
    func asURLRequest() throws -> URLRequest {
        URLRequest(url: URL(string: "http://www.naver.com")!)
    }
}
