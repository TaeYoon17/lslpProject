//
//  SignUpVM.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/14.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire
final class SignUpVM{
    
    let emailSubject = BehaviorSubject(value: "")
    let pwSubject = BehaviorSubject(value: "")
    let nickSubject = BehaviorSubject(value: "")
    let pageNumber = BehaviorSubject(value: 0)
    
    let maxPageNumber: Int
    var disposeBag = DisposeBag()
    let nextTapped: PublishSubject<Void> = .init()
    let prevTapped: PublishSubject<Void> = .init()
    let completedTapped: PublishSubject<Void> = .init()
    private let signUpSubject: PublishSubject<()> = .init()
//    private let signFailed: PublishSubject<ErrMsg> = .init()
    init(maxPageNumber: Int){
        self.maxPageNumber = maxPageNumber
        nextTapped.bind(with: self){ owner, _ in
            let nowVal = try! owner.pageNumber.value()
            owner.pageNumber.onNext(min(maxPageNumber - 1,nowVal + 1))
        }.disposed(by: disposeBag)
        prevTapped.bind(with: self) { owner, _ in
            let nowVal = try! owner.pageNumber.value()
            owner.pageNumber.onNext(max(0,nowVal - 1))
        }.disposed(by: disposeBag)
        completedTapped.subscribe(with: self) { owner, _ in
            Task{@MainActor in
                try await owner._signUp()
                self.signUpSubject.onNext(())
            }
        }.disposed(by: disposeBag)
    }
    struct Output{
        var signUp: PublishSubject<()> = .init()
        var signFailed: PublishSubject<ErrMsg> = .init()
    }
    func output() -> Output{
        let signFailed: PublishSubject<ErrMsg> = .init()
        NetworkService.shared.errSubject?.bind(to: signFailed).disposed(by: disposeBag)
        return Output(signUp: signUpSubject,signFailed: signFailed)
    }
    private func _signUp() async throws{
                let email = try emailSubject.value()
                let pw = try pwSubject.value()
                let nick = try nickSubject.value()
                let res = try await NetworkService.shared.signUp(user: .init(email: email, password: pw, nick: nick))
        print(res)
    }
}


