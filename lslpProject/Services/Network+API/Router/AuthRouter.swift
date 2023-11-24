//
//  AuthRouter.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/14.
//

import Foundation
import Alamofire
enum AuthRouter:URLRequestConvertible{
    case signUp(user: User),signIn(email:String,pw:String),emailValidation(email:String),refreshToken,withdraw
    var endPoint: String{
        switch self{
        case .signIn: "/login"
        case .signUp: "/join"
        case .emailValidation:"/validation/email"
        case .refreshToken: "/refresh"
        case .withdraw: "/withdraw"
        }
    }
    var method:HTTPMethod{
        switch self{
        case .emailValidation,.signUp,.signIn,.withdraw: .post
        case .refreshToken: .get
        }
    }
    var headers:HTTPHeaders{
        var headers = HTTPHeaders()
        switch self{
        case .withdraw:
            headers["Authorization"] = "token 값 넣기"
            headers["SesacKey"] = App.sesacKey
        case .refreshToken:
            headers["Refresh"] = "RefreshToken넣기"
        case .emailValidation,.signIn,.signUp: break
//            headers["Content-Type"] = "application/json"
//            headers["SesacKey"] = App.sesacKey
        }
        return headers
    }
    var parameters: Parameters{
        var params = Parameters()
        switch self{
        case .signUp(let user):
            params = user.convertToRequestBody
        case .emailValidation(let email):
            params["email"] = email
        case .signIn(let email,let pw):
            params["email"] = email
            params["password"] = pw
        default: break
        }
        return params
    }
    func asURLRequest() throws -> URLRequest {
        guard let url = URL(string: App.baseURL)?.appendingPathComponent(endPoint) else {
            throw Err.DataError.fetch
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.method = self.method
        urlRequest.headers = headers
        urlRequest.httpBody = try? JSONEncoding.default.encode(urlRequest, with: parameters).httpBody
        return urlRequest
    }
}
fileprivate extension User{
    var convertToRequestBody: Parameters{
        var params = Parameters()
        params["email"] = self.email
        params["password"] = self.password
        params["nick"] = self.nick
        if let phoneNum{ params["phoneNum"] = phoneNum }
        if let birthDay{ params["birthDay"] = birthDay}
        return params
    }
}
