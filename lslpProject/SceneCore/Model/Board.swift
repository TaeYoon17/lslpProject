//
//  Board.swift
//  lslpProject
//
//  Created by 김태윤 on 12/9/23.
//

import Foundation
struct Board:Identifiable,Hashable{
    var id = UUID()
    let name: String
    // 일단 이미지들의 문자열을 갖도록 하자
    let pinnedImage: [String]
    
}
