//
//  CreatingBoardVM.swift
//  lslpProject
//
//  Created by 김태윤 on 12/9/23.
//

import Foundation
import RxSwift
import RxCocoa
final class CreatingBoardVM{
    var board = Board()
    var disposeBag = DisposeBag()
    let name = BehaviorSubject(value: "")
    let isPrivacy = BehaviorSubject(value: false)
    let isLogOutAction = PublishSubject<Bool>()
    init(){
        Observable.combineLatest(name,isPrivacy).bind { [weak self] (name, isprivacy) in
            guard let self else {return}
            board.name = name
            board.isPrivacy = isprivacy
        }.disposed(by: disposeBag)
    }
    func upload(){
        let boardPost = BoardPost(name: board.name,isPrivacy: board.isPrivacy)
        print("Upload \(boardPost)")
        isLogOutAction.onNext(true)
//MARK: -- 업로드 네트워크
//        Task{
//            do{
//                try await NetworkService.shared.post(boardPost: boardPost)
//            }catch{
//                guard let networkError: Err.NetworkError = error as? Err.NetworkError else {
//                    print(error)
//                    return
//                }
//                print("오류 찾기")
//                if networkError == .epiredRefreshToken{
//                    
//                }
//            }
//        }
    }
}
