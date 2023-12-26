//
//  BoardWriteVM.swift
//  lslpProject
//
//  Created by 김태윤 on 12/27/23.
//

import Foundation
import Combine
class BoardWriteVM:ObservableObject{
    var board = Board()
    var subscription = Set<AnyCancellable>()
    @Published var name = ""
    @Published var isPrivacy = false
    @Published var tags:[Tag] = []
    @Published var imageData: Data?
    @Published var isUplodable: Bool = false
    init(){
        Publishers.CombineLatest4($name,$isPrivacy,$tags,$imageData).sink {[weak self] (name,isPrivacy,hashTags,data) in
            guard let self else {return}
            board.name = name
            board.isPrivacy = isPrivacy
            board.hashTags = hashTags.map{$0.text}
            if let imageData{
                board.data = imageData
            }
        }.store(in: &subscription)
    }
    func upload(){
        fatalError("Must be override!!")
    }
}
