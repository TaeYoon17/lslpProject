//
//  BoardCreateVM.swift
//  lslpProject
//
//  Created by 김태윤 on 12/26/23.
//

import Foundation
import Combine
final class BoardCreateVM: BoardWriteVM{
//    private var board = Board()
//    private var subscription = Set<AnyCancellable>()
//    @Published var name = ""
//    @Published var isPrivacy = false
//    @Published var tags:[Tag] = []
//    @Published var imageData: Data?
//    @Published var isUplodable: Bool = false
    override init(){
        super.init()
//        Publishers.CombineLatest4($name,$isPrivacy,$tags,$imageData).sink {[weak self] (name,isPrivacy,hashTags,data) in
//            guard let self else {return}
//            board.name = name
//            board.isPrivacy = isPrivacy
//            board.hashTags = hashTags.map{$0.text}
//            if let imageData{
//                board.data = imageData
//            }
//        }.store(in: &subscription)
        $name.map{!$0.isEmpty}.assign(to: &$isUplodable)
    }
    override func upload(){
//        MARK: -- 업로드 네트워크
        Task{
            var boardPost = BoardPost(name: board.name,isPrivacy: board.isPrivacy,data: imageData)
            boardPost.hashTags = board.hashTags.joined(separator: "-")
            do{
                let res = try await NetworkService.shared.post(boardPost: boardPost)
                print(res)
            }catch{
                guard let networkError: Err.NetworkError = error as? Err.NetworkError else {
                    print(error)
                    return
                }
                print("오류 찾기")
                if networkError == .epiredRefreshToken{
                    
                }
            }
        }
    }
}
