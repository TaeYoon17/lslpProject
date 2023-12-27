//
//  NetworkService+Board.swift
//  lslpProject
//
//  Created by 김태윤 on 12/27/23.
//

import Foundation
import Alamofire
import Combine
import RxSwift
extension NetworkService{
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
    func getUserBoard() async throws -> [Board]{
        let postread = PostRouter.read(next: nil, limit: nil, productId: "Board")
        let raws = try await withCheckedThrowingContinuation { continuation in
            AF.request(postread, interceptor: baseAuthenticator)
                .responseDecodable(of:PostCheckResponse.self){[weak self] result in
                    guard let self else {return}
                    switch result.result{
                    case .success(let success):
                        let raws = success.data.filter {$0.creator._id == self.userID }
                        continuation.resume(returning: raws)
                    case .failure(let error): print(error)
                        continuation.resume(throwing: error)
                    }
                    print(result.response?.statusCode)
                }
        }
        var boards:[Board] = []
        for rawData in raws{
            let board = await Board.getBy(checkData: rawData)
            boards.append(board)
        }
        return boards
    }
    func updateBoard(id: String,boardPost: BoardPost){
        let post = boardPost.get
        let postRouter = PostRouter.update(id: id, post: post)
        AF.upload(multipartFormData: postRouter.multipartFormData, with: postRouter,interceptor: baseAuthenticator)
            .uploadProgress { progress in
            print("\(progress)")
            }.responseString { result in
                switch result.result{
                case .success(let success):
                    print(success)
//                    continuation.resume(returning: "Success")
                case .failure(let error):
                    guard let networkError: Err.NetworkError = error.underlyingError as? Err.NetworkError else {
                        print(error)
                        return
                    }
//                    continuation.resume(throwing: networkError)
                }
            }
    }
    func deleteBoard(boardID:String){
        let postdelete = PostRouter.delete(id: boardID)
        AF.request(postdelete,interceptor: baseAuthenticator)
            .responseString {[weak self] result in
                guard let self else {return}
                switch result.result{
                case .success(let str):
                    print("----success---")
                    print(str)
                case .failure(let err):
                    print("---err---")
                    print(err)
                }
            }
    }
}
