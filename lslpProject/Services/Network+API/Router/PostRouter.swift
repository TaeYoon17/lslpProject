//
//  Router.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/14.
//

import Foundation
import Alamofire
enum PostRouter:URLRequestConvertible{
    case create(post:PostUpload),read,update,delete(id: String)
    var endPoint: String{
        switch self{
        case .create: "/post"
        case .delete(let id): "/post/\(id)"
        case .read: "/post"
        case .update: "/post"
        }
    }
    var method:HTTPMethod{
        switch self{
        case .create: .post
        case .delete: .delete
        case .read: .get
        case .update: .put
        }
    }
    var headers:HTTPHeaders{
        var headers = HTTPHeaders()
        headers["Authorization"] = ""
        headers["SesacKey"] = App.sesacKey
        switch self{
        case .create,.update:
            headers["Content-Type"] = "multipart/form-data"
        case .delete,.read: break
        }
        return headers
    }
    var parameters: Parameters{
        var params = Parameters()
        return params
    }
    func asURLRequest() throws -> URLRequest {
        guard let url = URL(string: App.baseURL)?.appendingPathComponent(endPoint) else {
            throw Err.DataError.fetch
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.method = self.method
        urlRequest.headers = headers
        switch self{
        case .create,.delete,.read: break
        default:
            urlRequest.httpBody = try? JSONEncoding.default.encode(urlRequest, with: parameters).httpBody
        }
        
        return urlRequest
    }
    var multipartFormData: MultipartFormData {
        let multipartFormData = MultipartFormData()
        switch self {
        case .create(let post):
            for (idx,data) in post.imageDatas.enumerated(){
                multipartFormData.append(data, withName: "file", fileName: "\(post.productId)\(idx).jpg", mimeType: "image/png")
            }
        default: ()
        }
        return multipartFormData
    }
}
