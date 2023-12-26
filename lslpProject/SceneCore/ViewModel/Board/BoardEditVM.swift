//
//  BoardEditVM.swift
//  lslpProject
//
//  Created by 김태윤 on 12/27/23.
//

import Foundation
import Combine
final class BoardEditVM: BoardWriteVM{
    let originBoard:Board
//    private var board = Board()
//    var subscription = Set<AnyCancellable>()
//    @Published var name = ""
//    @Published var isPrivacy = false
//    @Published var tags:[Tag] = []
//    @Published var imageData: Data?
//    @Published var isUplodable: Bool = false
    init(_ originBoard: Board){
        self.originBoard = originBoard
        super.init()
        self.name = originBoard.name
        self.isPrivacy = originBoard.isPrivacy
        self.tags = originBoard.hashTags.map{Tag(text: $0)}
//        Publishers.CombineLatest4($name,$isPrivacy,$tags,$imageData).sink {[weak self] (name,isPrivacy,hashTags,data) in
//            guard let self else {return}
//            self.board.name = name
//            self.board.isPrivacy = isPrivacy
//            self.board.hashTags = hashTags.map{$0.text}
//            if let imageData{
//                self.board.data = imageData
//            }
//        }.store(in: &subscription)
        makeUplodable()
    }
    private func makeUplodable(){
        let (boardName,hashTags,privacy) = (originBoard.name, originBoard.hashTags, originBoard.isPrivacy)
        let pub1 = $name.map{ !$0.isEmpty && $0 != boardName }
        let pub2 = $imageData.map{$0 != nil}
        let pub3 = $tags.map{$0.map(\.text) != hashTags}
        let pub4 = $isPrivacy.map{ $0 != privacy}
        Publishers.CombineLatest4(pub1, pub2, pub3,pub4).map{ $0 || $1 || $2 || $3}.assign(to: &$isUplodable)
    }
    override func upload(){
        
    }
}
