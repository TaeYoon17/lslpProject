//
//  SignInVM.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/25.
//

import Foundation
import RxSwift
import RxCocoa

final class SignInVM{
    var disposeBag = DisposeBag()
    deinit{
        print("SignInVM은 집갔다!!")
    }
    struct Input{
        let idInput:  BehaviorSubject<String>
        let pwInput: BehaviorSubject<String>
        let signInTap: ControlEvent<Void>
    }
    struct Output{
        let singInResponse: PublishSubject<String?>
    }
    func output(_ input: Input)->Output{
        let signInResponse = PublishSubject<String?>()
        let signInTappedStream = input.signInTap.asObservable().values
        Task{
            do{
                for try await _ in signInTappedStream{
                    let id = try input.idInput.value()
                    let pw = try input.pwInput.value()
//                    print(id,pw)
                    //MARK: -- 서비스 실제 사용 시 바꿈
                    let response:SignInRespone = try await NetworkService.shared.signIn(email: App.virtualEmail, pw: App.virtualPW)
//                    print("------------",response)
                    App.Manager.shared.signIn(response)
                    signInResponse.onNext(nil)
                }
            }catch{
                print(error)
                signInResponse.onNext(error.localizedDescription)
            }
        }
        return Output(singInResponse: signInResponse)
    }
}
