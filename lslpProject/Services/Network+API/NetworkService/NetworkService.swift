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
    @DefaultsState(\.userID) var userID
    var errSubject:PublishSubject<ErrMsg>?
    var baseAuthenticator: AuthenticationInterceptor<MyAuthenticator>{
        let authenticator = MyAuthenticator()
        let credential = AuthCredential(expiration: Date(timeIntervalSinceNow: 60))
        let intercentptor = AuthenticationInterceptor(authenticator: authenticator,credential: credential)
        return intercentptor
    }
    private init(){}
    private var boardCursor = "0"
//    func post(pinPost: PinPost){
//        let post = pinPost.get
//        let postRouter = PostRouter.create(post: post)
//        AF.upload(multipartFormData: postRouter.multipartFormData, with: postRouter).uploadProgress { progress in
//            print("\(progress)")
//        }.validate()
//        .responseData { response in
//            print("\(String(describing: response.response?.statusCode))")
//        }
//    }
    
    func getPost(id: String ){
        let postread = PostRouter.read(next: boardCursor, limit: 5, productId: "Board")
        AF.request(postread, interceptor: baseAuthenticator).responseString { result in
            switch result.result{
            case .success(let success):
                print(success)
            case .failure(let error): print(error)
            }
            print(result.response?.statusCode)
        }
    }
    func getImageData(imagePath:String) async throws -> Data{
        guard let imageURL = URL(string: "\(App.baseURL)/\(imagePath)") else {
            throw Err.DataError.fetch
        }
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(imageURL,interceptor: baseAuthenticator).response { result in
                switch result.result{
                case .success(let success?):
                    continuation.resume(returning: success)
                case .success(nil):
                    continuation.resume(throwing: Err.FetchError.fetchEmpty)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
                print(result.response?.statusCode)
            }
        }
    }
}
struct ErrMsg:Codable{
    var message:String
}


