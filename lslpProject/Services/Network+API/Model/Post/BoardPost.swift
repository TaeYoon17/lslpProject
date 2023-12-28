//
//  Board.swift
//  lslpProject
//
//  Created by 김태윤 on 12/9/23.
//

import Foundation
struct Board:Identifiable,Hashable{
    private var productId: String = "Board"
    var id:String = UUID().uuidString
    var name: String = ""
    var hashTags: [String] = [] // 이거 변형시켜야함
    var data:Data?
    var pinCounts:Int{ pins.reduce(0) { $0 + $1.count } }
    var pins:[[String]] = Array(repeating: [], count: 5)
    static func getBy(checkData data:PostCheckResponse.CheckData) async ->Board{
        var board = Board()
        board.id = data._id
        board.name = data.title ?? ""
        if let content1 = data.content{
            board.hashTags = content1.split(separator: "-").map{String($0).replacing("#", with: "")}
        }
        if let imagePath = data.image.first{
            board.data = try? await NetworkService.shared.getImageData(imagePath: imagePath)
        }
        return board
    }
    mutating func insertPinID(pinID: String)-> Bool{
        for idx in (0..<5){
            if pins[idx].count >= 10{ continue }
            pins[idx].append(pinID)
            return true
        }
        return false
    }
}
struct BoardPost:Codable{
    var id = UUID().uuidString
    private var productId: String = "Board"
    var name:String = ""
    var hashTags: String = ""
    var data:Data?
    var pins = Array(repeating: "", count: 5)
    var get: Post{
        var post = Post(title: name,product_id: productId,content: hashTags,
                        content1: pins[0],content2: pins[1],content3: pins[2],content4: pins[3],content5: pins[4])
        if let data{
            post.file = [data]
        }
        return post
    }
    
    init(){}
    init(name: String, hashTags: String, data: Data? = nil) {
        self.name = name
        self.hashTags = hashTags
        self.data = data
    }
    init(board:Board){
        self.name = board.name
        self.id = board.id
        self.hashTags = board.hashTags.map{"#\($0)"}.joined(separator: "-")
        self.data = board.data
        self.pins = board.pins.compactMap { $0.joined(separator:"#")}
    }
    var getOriginal:Board{
        var board = Board()
        board.name = self.name
        board.data = self.data
        board.hashTags = hashTags.split(separator: "-").map{String($0).replacing("#", with: "")}
        board.id = self.id
        board.pins = self.pins.reduce(into: [], {
            $0.append($1.components(separatedBy: "#"))
        })
        return board
    }
}
