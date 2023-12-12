//
//  ProfileRouter.swift
//  lslpProject
//
//  Created by 김태윤 on 12/12/23.
//

import Foundation
import Alamofire
enum ProfileRouter:URLRequestConvertible{
    case check,edit(profile:ProfileEditBody),other(id:String)
    var endPoint: String{
        switch self{
        case .check: "/profile/me"
        case .edit: "/profile/me"
        case .other(id: let id): "/profile/\(id)"
        }
    }
    var method:HTTPMethod{
        switch self{
        case .check: .get
        case .edit: .put
        case .other: .get
        }
    }
    var headers:HTTPHeaders{
        var headers = HTTPHeaders()
        switch self{
        case .check: break
        case .edit: headers["Content-Type"] = "multipart/form-data"
        case .other: break
        }
        return headers
    }
    var parameters: Parameters{
        let params = Parameters()
        switch self{
        case .check: break
        case .edit: break
        case .other: break
        }
        return params
    }
    func asURLRequest() throws -> URLRequest {
        guard let url = URL(string: App.baseURL)?.appendingPathComponent(endPoint) else {
            throw Err.DataError.fetch
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.method = self.method
        urlRequest.headers = headers
        switch self.method{
        case .get: break
        default:
            urlRequest.httpBody = try? JSONEncoding.default.encode(urlRequest, with: parameters).httpBody
        }
        
        return urlRequest
    }
    var multipartFormData: MultipartFormData {
        let multipartFormData = MultipartFormData()
        switch self {
        case .edit(let profile):
            let nameArr = ["nick","birthDay","phoneNum"]
            let profileArr:[String?] = [profile.nick,profile.birthDay,profile.phoneNum]
            for (name,profile) in zip(nameArr,profileArr){
                if let profile{
                    multipartFormData.append(Data(profile.utf8), withName: name)
                }
                
            }
            guard let profileData = profile.profile else {break}
            multipartFormData.append(profileData, withName: "file",fileName: "\(profile.nick ?? "")\(profile.birthDay ?? "").jpg",mimeType: "image/png")
        default: ()
        }
//        print("multipart called \(multipartFormData)")
        return multipartFormData
    }
}
