//
//  NetworkService+Profile.swift
//  lslpProject
//
//  Created by 김태윤 on 12/12/23.
//

import Foundation
import Alamofire
import RxSwift
extension NetworkService{
    func getMyProfile() async throws{
        let getProfileRouter = ProfileRouter.check
        AF.request(getProfileRouter, interceptor: baseAuthenticator).response { result in
            switch result.result{
            case .success(let data): break
            case .failure(let error): break
            }
            print(result.response?.statusCode)
        }
    }
    func editProfile(nick:String,phoneNum:String? = nil,birthDay:String? = nil,profile:Data? = nil) async throws{
        let profileEditBody = ProfileEditBody(nick: nick, phoneNum: phoneNum, birthDay: birthDay, profile: profile)
        
        let editProfileRouter = ProfileRouter.edit(profile: profileEditBody)
        AF.upload(multipartFormData: editProfileRouter.multipartFormData, with: editProfileRouter,interceptor: baseAuthenticator)
            .uploadProgress { progress in
                print("\(progress)")
            }.response{result in
                switch result.result{
                case .success(let success): print("success")
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
}
