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
    private init(){}
    
    //    func post(pinUpload:PinPostUpload){
    //
    //        let postRouter = PostRouter.create(post: pinUpload)
    //        AF.upload(multipartFormData: postRouter.multipartFormData, with: postRouter).uploadProgress(closure: { (progress) in
    //            print("\(progress)")
    //         })
    //         .validate()
    //         .responseData(completionHandler: { (response) in
    //             print("\(response)")
    //             print("\(response.response?.statusCode)")
    //         })
    //    }
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
    func post(boardPost: BoardPost){
        let post = boardPost.get
        print(accessToken)
        let postRouter = PostRouter.create(post: post)
        let authenticator = MyAuthenticator()
        let credential = AuthCredential(expiration: Date(timeIntervalSinceNow: Self.accessExpireSeconds))
        let intercentptor = AuthenticationInterceptor(authenticator: authenticator,credential: credential)
        
        AF.upload(multipartFormData: postRouter.multipartFormData, with: postRouter,interceptor: PostInterceptor())
            .uploadProgress { progress in
            print("\(progress)")
        }.validate()
        .responseData { response in
            switch response.result{
            case .success(let data): print("success")
            case .failure(let err): print(err)
            }
//            print("\(response.response?.statusCode ?? -1)")
        }
    }
}
struct ErrMsg:Codable{
    var message:String
}

