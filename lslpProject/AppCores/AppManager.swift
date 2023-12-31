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
        @DefaultsState(\.accessToken) var accessToken
        @DefaultsState(\.refreshToken) var refreshToken
        @DefaultsState(\.userBoards) private(set) var boards
        @DefaultsState(\.userHashTags) private(set) var hashTags
        static let shared = Manager()
        let addAction = PublishSubject<Void>()
        let userAccount = PublishSubject<Bool>()
        let needLogIn = PublishSubject<Bool>()
        let hideTabbar = PublishSubject<Bool>()
        private init(){}
    }
}

extension App.Manager{
    func signIn(_ response:SignInRespone){
        self.accessToken = response.accessToken
        self.refreshToken = response.refreshToken
        self.userAccount.onNext(true)
    }
    func updateBoards(boards:[Board]){
        self.boards = boards
        Task{
            let tags:[String] = boards.flatMap{$0.hashTags}
            self.hashTags = Array(Set(tags))
        }
    }
}
