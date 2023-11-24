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
