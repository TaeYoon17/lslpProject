//
//  Router.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/14.
//

import Foundation
import Alamofire
enum PostRouter:URLRequestConvertible{
    case create(post:Post),read(next:String?,limit:Int?,productId:String?),update,delete(id: String)
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
        switch self{
        case .create,.update:
            headers["Content-Type"] = "multipart/form-data"
        case .delete,.read: break
        }
        return headers
    }
    var parameters: Parameters{
        var params = Parameters()
        switch self{
        case .create(post: let post): break
        case .read(next: let next, limit: let limit, productId: let productId):
            if let limit { params["limit"] = "\(limit)" }
            if let next {params["next"] = next}
            if let productId {params["product_id"] = productId}
        default: break
        }
        return params
    }
    func asURLRequest() throws -> URLRequest {
        guard var url = URL(string: App.baseURL)?.appendingPathComponent(endPoint) else {
            throw Err.DataError.fetch
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.method = self.method
        urlRequest.headers = headers
        switch self{
        case .create,.delete: break
        case .read:
            let queryItems = parameters.map{URLQueryItem(name: $0.key, value: $0.value as? String ?? "")}
//            url.append(queryItems: queryItems)
            urlRequest.url?.append(queryItems: queryItems)
            print(urlRequest.url?.absoluteString)
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
//        print("multipart called \(multipartFormData)")
        return multipartFormData
    }
}
