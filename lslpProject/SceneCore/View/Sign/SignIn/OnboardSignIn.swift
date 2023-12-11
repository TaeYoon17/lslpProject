//
//  SignInVC.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
final class OnboardSignIn: SignInVC{
    let vm = SignInVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapAction = loginBtn.rx.tap
        guard let idText = idInputView.bindings?.text, let pwText = pwInputView.bindings?.text else {return}
        let output = vm.output(.init(idInput:idText ,pwInput: pwText ,signInTap:tapAction ))
        output.singInResponse
            .debounce(.microseconds(1), scheduler: MainScheduler.instance)
            .bind(with: self) { owner, val in
                if let val{
                    let alert = UIAlertController(title: "에러존재", message: nil, preferredStyle: .alert)
                    let action = UIAlertAction(title: "취소", style: .cancel)
                    alert.addAction(action)
                    owner.present(alert, animated: true)
                }else{ // 로그인 성공
                    //                owner.closeAction()
                }
            }.disposed(by: disposeBag)
        
        Observable.combineLatest(idText, pwText).map { left,right in
            !left.isEmpty && !right.isEmpty
        }.bind(to: loginBtn.isAvailableLogIn).disposed(by: disposeBag)
    }
    override func configureNavigation() {
        super.configureNavigation()
                self.navigationItem.leftBarButtonItem = .init(systemItem: .cancel)
                self.navigationItem.leftBarButtonItem?.rx.tap.bind(with: self) { owner, _ in
                    owner.closeAction()
                }.disposed(by: disposeBag)
    }
}
