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
    var disposeBag = DisposeBag()
    
    struct Input{
        
    }
    
    struct Output{
        
    }
    init(){
//        disposeBag = DisposeBag()
//        print("")
//        Task{
//            do{
//                let res = try await NetworkService.shared.signUp(user: .init(email: "zz@gmail.com", password: "1994", nick: "lg우승", phoneNum: "12"))
//            }catch{
//                print(error)
//            }
//        }
//        NetworkService.shared.errSubject?.subscribe(with: self){ owner, val in
//            print(val.message)
//        }.disposed(by: disposeBag)
    }
}

struct SignUpResponse:Codable{
    let _id: String
    let email:String
    let nick: String
    enum CodingKeys: String, CodingKey {
        case _id = "_id",email = "email",nick = "nick"
    }
}
