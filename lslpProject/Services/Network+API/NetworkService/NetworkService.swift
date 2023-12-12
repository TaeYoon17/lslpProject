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
    @DefaultsState(\.accessToken) var accessToken
    @DefaultsState(\.refreshToken) var refreshToken
    var errSubject:PublishSubject<ErrMsg>?
    var baseAuthenticator: AuthenticationInterceptor<MyAuthenticator>{
        let authenticator = MyAuthenticator()
        let credential = AuthCredential(expiration: Date(timeIntervalSinceNow: 60))
        let intercentptor = AuthenticationInterceptor(authenticator: authenticator,credential: credential)
        return intercentptor
    }
    private init(){}
    
    func post(pinPost: PinPost){
        let post = pinPost.get
        let postRouter = PostRouter.create(post: post)
        AF.upload(multipartFormData: postRouter.multipartFormData, with: postRouter).uploadProgress { progress in
            print("\(progress)")
        }.validate()
        .responseData { response in
            print("\(String(describing: response.response?.statusCode))")
        }
    }
    func post(boardPost: BoardPost) async throws -> String{
        let post = boardPost.get
        let postRouter = PostRouter.create(post: post)
        return try await withCheckedThrowingContinuation { continuation in
            AF.upload(multipartFormData: postRouter.multipartFormData, with: postRouter,interceptor: baseAuthenticator)
                .uploadProgress { progress in
                print("\(progress)")
                }.response { result in
                    switch result.result{
                    case .success(let success): print("success")
                        continuation.resume(returning: "Success")
                    case .failure(let error):
                        guard let networkError: Err.NetworkError = error.underlyingError as? Err.NetworkError else {
                            print(error)
                            return
                        }
                        continuation.resume(throwing: networkError)
                    }
                }
        }
    }
}
struct ErrMsg:Codable{
    var message:String
}


