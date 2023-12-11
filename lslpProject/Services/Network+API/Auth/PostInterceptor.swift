//
//  PostInterceptor.swift
//  lslpProject
//
//  Created by 김태윤 on 12/10/23.
//

import Foundation
import Alamofire
final class PostInterceptor: RequestInterceptor {
    @DefaultsState(\.accessToken) var accessToken
    @DefaultsState(\.refreshToken) var refreshToken
//    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
//        var request = urlRequest
//        var headers = HTTPHeaders()
//        headers["Authorization"] = accessToken
//        headers["SesacKey"] = App.sesacKey
//        headers["Content-Type"] = "multipart/form-data"
//        request.headers = headers
//        completion(.success(request))
//    }
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        print("retry called")
        if request.response?.statusCode == 419{
            AF.request(AuthRouter.refreshToken,interceptor: BaseInterceptor())
                .responseDecodable(of: TokenResponse.self){[weak self] result in
                guard let self else {return}
                switch result.result{
                case .success(let value):
                    self.accessToken = value.token
                    let expiration = Date(timeIntervalSinceNow: NetworkService.accessExpireSeconds)
                    print("성공")
                    completion(.doNotRetry)
                case .failure(let error):
                    print("에러 발생 \(result.response?.statusCode) \n \(error) ")
                    completion(.doNotRetryWithError(error))
                }
            }
        }else{
            completion(.doNotRetryWithError(error))
        }
    }
}
