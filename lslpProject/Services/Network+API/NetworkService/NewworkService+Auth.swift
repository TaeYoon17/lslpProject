//
//  NewworkService+Auth.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/25.
//

import Foundation
import Alamofire
extension NetworkService{
    func signUp(user: User) async throws -> SignUpResponse {
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(AuthRouter.signUp(user: user),interceptor: BaseInterceptor())
                .validate(statusCode: 200...299)
                .responseDecodable(of: SignUpResponse.self) { res in
                    switch res.result{
                    case .success(let response):
                        continuation.resume(returning: response)
                    case .failure(let error):
                        if let data = res.data{
                            if let msg = try? JSONDecoder().decode(ErrMsg.self, from: data){
                                self.errSubject?.onNext(msg)
                            }
                        }
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
    func signIn(email:String,pw:String) async throws -> SignInRespone{
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(AuthRouter.signIn(email: email, pw: pw), interceptor: BaseInterceptor()).validate(statusCode: 200...299)
                .responseDecodable(of: SignInRespone.self){[weak self] res in
                    switch res.result{
                    case .success(let response):
                        self?.refreshToken = response.refreshToken
                        self?.accessToken = response.accessToken
                        continuation.resume(returning: response)
                    case .failure(let error):
                        if let data = res.data{
                            if let msg = try? JSONDecoder().decode(ErrMsg.self, from: data){
                                self?.errSubject?.onNext(msg)
                            }
                        }
                        continuation.resume(throwing: error)
                    }
            }
        }
    }
}
