//
//  AuthCredentail.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/24.
//

import Foundation
import Alamofire
struct AuthCredential : AuthenticationCredential {
    @DefaultsState(\.accessToken) var accessToken
    @DefaultsState(\.refreshToken) var refreshToken
    let expiration: Date
    var requiresRefresh: Bool { Date(timeIntervalSinceNow: NetworkService.accessExpireSeconds) > expiration }
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        
        var request = urlRequest
        // 헤더 부분 넣어주기
        print(urlRequest.httpMethod ?? "")
        request.addValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json; charset=UTF-8", forHTTPHeaderField: "Accept")
        request.addValue(App.sesacKey, forHTTPHeaderField: "SesacKey")
        completion(.success(request))
    }
}
