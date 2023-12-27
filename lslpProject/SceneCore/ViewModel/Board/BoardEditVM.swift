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
    init(_ originBoard: Board){
        self.originBoard = originBoard
        super.init()
        self.board.id = originBoard.id
        self.board.data = originBoard.data
        self.name = originBoard.name
        self.tags = originBoard.hashTags.map{Tag(text: $0)}
        makeUplodable()
    }
    private func makeUplodable(){
        let (boardName,hashTags) = (originBoard.name, originBoard.hashTags)
        let pub1 = $name.map{ !$0.isEmpty && $0 != boardName }
        let pub2 = $imageData.map{$0 != nil}
        let pub3 = $tags.map{$0.map(\.text) != hashTags}
        
        Publishers.CombineLatest3(pub1, pub2, pub3).map{ $0 || $1 || $2 }.assign(to: &$isUplodable)
    }
    override func upload(){
        let boardPost = BoardPost(board: board)
        print(boardPost)
        NetworkService.shared.updateBoard(id: board.id, boardPost: boardPost)
        
    }
    func delete(){
        print(originBoard.id)
        NetworkService.shared.deleteBoard(boardID: originBoard.id)
        
    }
}
