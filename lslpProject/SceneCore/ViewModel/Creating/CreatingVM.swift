//
//  CreatingVM.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/23.
//

import Foundation
import RxSwift
import RxCocoa
final class CreatingVM{
    var startCreateType = PublishSubject<App.CreateType>()
}

extension CreatingVM{
    struct Output{
        let startCreateType:PublishSubject<App.CreateType>
    }
    func transform()->Output{
        Output(startCreateType: startCreateType)
    }
}
