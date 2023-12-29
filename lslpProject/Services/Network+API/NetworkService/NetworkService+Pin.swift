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
    
}
