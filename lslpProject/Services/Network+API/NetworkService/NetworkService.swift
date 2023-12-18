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
                }.responseString { result in
                    switch result.result{
                    case .success(let success):
                        print(success)
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
    func getBoard(userID: String) async throws -> [Board]{
        let postread = PostRouter.read(next: nil, limit: nil, productId: "Board")
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(postread, interceptor: baseAuthenticator)
                .responseDecodable(of:PostCheckResponse.self){[weak self] result in
                    guard let self else {return}
                    switch result.result{
                    case .success(let success):
                        let datas = success.data.filter {$0.creator._id == userID }.map{Board.getBy(checkData: $0)}
                        continuation.resume(returning: datas)
                    case .failure(let error): print(error)
                        continuation.resume(throwing: error)
                    }
                    print(result.response?.statusCode)
                }
        }
    }
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


