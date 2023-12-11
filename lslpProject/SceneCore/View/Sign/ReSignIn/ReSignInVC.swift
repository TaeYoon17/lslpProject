//
//  File.swift
//  lslpProject
//
//  Created by 김태윤 on 12/11/23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
final class ReSignInVC:SignInVC{
    let vm = SignInVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        idInputView.textField.isUserInteractionEnabled = false
        let tapAction = loginBtn.rx.tap
        guard let idText = idInputView.bindings?.text, let pwText = pwInputView.bindings?.text else {return}
        let output = vm.output(.init(idInput:idText ,pwInput: pwText ,signInTap:tapAction ))
        idText.onNext("helloword@naver.com")
        output.singInResponse
            .debounce(.microseconds(1), scheduler: MainScheduler.instance)
            .bind(with: self) { owner, val in
                if let val{
                    let alert = UIAlertController(title: "에러존재", message: nil, preferredStyle: .alert)
                    let action = UIAlertAction(title: "취소", style: .cancel)
                    alert.addAction(action)
                    owner.present(alert, animated: true)
                }else{ // 로그인 성공
                    owner.closeAction()
                }
            }.disposed(by: disposeBag)
        Observable.combineLatest(idText, pwText).map { left,right in
            print(left,right)
            return !left.isEmpty && !right.isEmpty
        }.bind(to: loginBtn.isAvailableLogIn).disposed(by: disposeBag)
    }
    override func configureNavigation() {
        super.configureNavigation()
        navigationItem.rightBarButtonItem = .init(title: "LogOut")
        navigationItem.rightBarButtonItem?.rx.tap.bind(with: self) { owner, _ in
            App.Manager.shared.userAccount.onNext(false)
        }.disposed(by: disposeBag)
        self.isModalInPresentation = true
    }
}
