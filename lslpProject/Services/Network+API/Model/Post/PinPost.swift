//
//  Post.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/23.
//

import Foundation
import UIKit
struct PinPost:Codable{
    var productId: String = "Pin"
    var title: String = ""
    var content: String?
    var link: String?
    var imageDatas: [Data] = []
    var board: String = ""
    var hashTags: String = ""
    var get:Post{
        let post = Post(title: title,product_id: productId,content: hashTags,file: imageDatas,content1: content,content2: link,content3: board)
        print("get Post")
        print(post)
        return post
    }
}
struct Pin:Identifiable,Hashable{
    static func == (lhs: Pin, rhs: Pin) -> Bool {
        lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var product_id = "Pin"
    var id:String
    var likes:[String]
    var images:[Data]
    var hashTags:[String]
    var comments:[Comment]
    var creator:User
    var boardID: String
    var content: String
    var link:String
    init(response: PostCheckResponse.CheckData) async throws {
        let counter = TaskCounter()
        self.images = try await counter.run(response.image) { imagePath in
            try await NetworkService.shared.getImageData(imagePath: imagePath)
        }
        self.id = response._id
        self.likes = response.likes
        self.hashTags = response.hashTags
        self.comments = response.comments
        self.creator = response.creator
        self.boardID = response.content3 ?? ""
        self.content = response.content1 ?? ""
        self.link = response.content2 ?? ""
    }
}

