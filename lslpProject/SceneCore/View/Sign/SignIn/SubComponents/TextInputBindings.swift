//
//  TextInputBindings.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/27.
//

import Foundation
import RxSwift
struct TextInputBindings{
    var text = BehaviorSubject(value: "")
    var placeholder :String
    var inputInfo: String
    init(placeholder: String, inputInfo: String) {
        self.placeholder = placeholder
        self.inputInfo = inputInfo
    }
    init(text:String,placeholder: String, inputInfo: String) {
        self.text = .init(value: text)
        self.placeholder = placeholder
        self.inputInfo = inputInfo
    }
}
