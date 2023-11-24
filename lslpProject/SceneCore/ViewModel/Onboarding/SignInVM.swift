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
    struct Input{
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
                    let response = try await NetworkService.shared.signIn(email: "wow@gmail.com", pw: "1234")
                    print("------------")
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
