//
//  NetworkService+Pin.swift
//  lslpProject
//
//  Created by 김태윤 on 12/29/23.
//

import Foundation
import Alamofire
import Combine
import RxSwift
extension NetworkService{
    func post(pinPost: PinPost) async throws/* -> String*/{
        let post = pinPost.get
        let postRouter = PostRouter.create(post: post)
        //        return try await withCheckedThrowingContinuation { continuation in
        AF.upload(multipartFormData: postRouter.multipartFormData,
                  with: postRouter,interceptor: baseAuthenticator)
        .uploadProgress { progress in
            print("\(progress)")
        }.responseString { result in
            switch result.result{
            case .success(let success):
                print(success)
                //                        continuation.resume(returning: "Success")
            case .failure(let error):
                print(error)
                guard let networkError: Err.NetworkError = error.underlyingError as? Err.NetworkError else {
                    print(error)
                    return
                }
                //                        continuation.resume(throwing: networkError)
            }
            //                }
        }
        
    }
    func getPin(){
        let postRouter = PostRouter.read(next: nil, limit: nil, productId: "Pin")
        AF.request(postRouter, interceptor: baseAuthenticator).responseString { res in
            switch res.result{
            case .success(let result):
                print("Get Pin Result")
                print(result)
            case .failure(let error) :
                print(error)
            }
        }
    }
    func hashTags(_ tags:[String]) async throws -> [Pin]{
        let pins:[[Pin]] = try await counter.run(tags) {[weak self] tag in
            guard let self else {return []}
            let datas = try await makeRequest(tag) // 태그 검색 결과로 받아온 핀들
            var pins:[Pin] = []
            for data in datas{
                let pin = try await Pin(response: data)
                pins.append(pin)
            }
            return pins
        }
        return pins.flatMap{$0}
    }
    func getUserPins(next:String? = nil) async throws -> ([Pin],String?){
        let postRead = PostRouter.read(next: next, limit: nil, productId: "Pin")
        let (allPinDatas,nextCursor) = try await getUserPost(router: postRead)
        var pins:[Pin] = []
        for pinData in allPinDatas{
            let pin = try await Pin(response: pinData)
            pins.append(pin)
        }
        return (pins,nextCursor)
    }
    private func makeRequest(_ tag:String)async throws -> [PostCheckResponse.CheckData]{
        let postRouter = PostRouter.hashTag(name: tag, next: nil, limit: nil, productId: "Pin")
        return try await getPost(router: postRouter).0
    }
    private func getPost(router:PostRouter) async throws -> ([PostCheckResponse.CheckData],String){
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(router,interceptor: baseAuthenticator).responseDecodable(of:PostCheckResponse.self){ result in
                switch result.result{
                case .success(let success):
                    print("-----success------")
                    continuation.resume(returning: (success.data,success.next_cursor))
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    private func getUserPost(router:PostRouter) async throws ->  ([PostCheckResponse.CheckData],String){
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(router,interceptor: baseAuthenticator).responseDecodable(of:PostCheckResponse.self){ result in
                switch result.result{
                case .success(let success):
                    print("-----success------")
                    let raws = success.data.filter {$0.creator._id == self.userID }
                    continuation.resume(returning: (raws,success.next_cursor))
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
