//
//  Authenticator.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/24.
//

import Foundation
import Alamofire
final class MyAuthenticator: Authenticator{
    @DefaultsState(\.accessToken) var accessToken
    @DefaultsState(\.refreshToken) var refreshToken
    typealias Credential = AuthCredential
    
    // Interceptor에서 본 추가할 헤더 코드들을 넣는 메서드와 같음
    // inout으로 URLRequest에 헤더 추가시 바로 적용된다.
    func apply(_ credential: Credential, to urlRequest: inout URLRequest) {
        urlRequest.addValue(App.sesacKey, forHTTPHeaderField: "SesacKey")
        urlRequest.addValue(credential.accessToken, forHTTPHeaderField: "Authorization")
    }
    // 인터셉터에서는 요청 결과를 419 코드로 받으면 요청을 재검사할 필요가 있다고 본다.
    func didRequest(_ urlRequest: URLRequest, with response: HTTPURLResponse, failDueToAuthenticationError error: Error) -> Bool {
        print("didRequest")
        return response.statusCode == 419
    }
    // 요청한 결과에 대해서 다시한번 재확인
    func isRequest(_ urlRequest: URLRequest, authenticatedWith credential: Credential) -> Bool {
        return credential.accessToken == self.accessToken
    }
    func refresh(_ credential: Credential, for session: Session, completion: @escaping (Result<Credential, Error>) -> Void) {
        let request = session.request(AuthRouter.refreshToken,interceptor: BaseInterceptor())
        request.responseDecodable(of: TokenResponse.self){[weak self] result in
            guard let self else {return}
            switch result.result {
            case .success(let value):
                // 재발행 받은 토큰 저장
                self.accessToken = value.token
                let expiration = Date(timeIntervalSinceNow: NetworkService.accessExpireSeconds)
                // 새로운 크리덴셜
                let newCredential = AuthCredential(expiration: expiration)
                completion(.success(newCredential))
            case .failure(let error):
                if let networkError = Err.NetworkError(rawValue: result.response?.statusCode ?? 0){
                    completion(.failure(networkError))
                }else{
                    completion(.failure(error))
                }
            }
        }
    }
}
