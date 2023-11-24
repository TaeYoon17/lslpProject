//
//  NetworkService.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/14.
//

import Foundation
import Alamofire
import RxSwift
final class NetworkService{
    static let accessExpireSeconds:Double = 60
    static let shared = NetworkService()
    var errSubject:PublishSubject<ErrMsg>?
    private init(){}
    func signUp(user: User) async throws -> SignUpResponse {
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(AuthRouter.signUp(user: user))
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
    func uploadPost(_ post:PostUpload){
        let postRouter = PostRouter.create(post: post)
        AF.upload(multipartFormData: postRouter.multipartFormData, with: postRouter).uploadProgress(closure: { (progress) in
            print("\(progress)")
         })
         .validate()
         .responseData(completionHandler: { (response) in
             print("\(response)")
             print("\(response.response?.statusCode)")
         })
    }
}
struct ErrMsg:Codable{
    var message:String
}
