//
//  Router.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/14.
//

import Foundation
import Alamofire
enum PostRouter:URLRequestConvertible{
    case create(post:Post),read,update,delete(id: String)
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
        @DefaultsState(\.accessToken) var accessToken
        headers["Authorization"] = accessToken
        headers["SesacKey"] = App.sesacKey
        switch self{
        case .create,.update:
            headers["Content-Type"] = "multipart/form-data"
        case .delete,.read: break
        }
//        headers = HTTPHeaders()
        return headers
    }
    var parameters: Parameters{
        var params = Parameters()
        switch self{
        case .create(post: let post): break
//            if let title = post.title{ params["title"] = title }
//            if let product_id = post.product_id {params["product_id"] = product_id}
//            params["content"] = post.content
//            params["content1"] = post.content1
//            params["content2"] = post.content2
//            params["content3"] = post.content3
//            params["content4"] = post.content4
//            params["content5"] = post.content5
        default: break
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
            let nameArr = ["title","product_id","content","content1","content2","content3","content4","content5"]
            let postArr:[String?] = [post.title,post.product_id,post.content,post.content1,post.content2,post.content3,post.content4,post.content5]
            for (name,post) in zip(nameArr,postArr){
                if let post{
                    multipartFormData.append(Data(post.utf8), withName: name)
                }
            }
            guard let file = post.file else {break}
            for (idx,data) in file.enumerated(){
                multipartFormData.append(data, withName: "file", fileName: "\(post.product_id ?? "")\(idx).jpg", mimeType: "image/png")
            }
        default: ()
        }
        print("multipart called \(multipartFormData)")
        return multipartFormData
    }
}
