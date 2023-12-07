//
//  AppManager.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/20.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
extension App{
    final class Manager{
        static let shared = Manager()
        let addAction = PublishSubject<Void>()
        let userAccount = PublishSubject<Bool>()
        private init(){}
        
    }
}
