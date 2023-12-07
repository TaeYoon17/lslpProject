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
final class SignInVC: BaseVC{
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
    let tempBtn = UIButton(configuration: .filled())
    let idInputView = EmailInput()
    let pwInputView = PasswordInput()
    let loginBtn = LogInBtn(text: "Log in", textColor: .white, bgColor: .systemGreen,holderColor: .systemGray5,holderBgColor: .lightGray)
    lazy var forgotBtn = {
        let btn = UIButton()
        btn.setAttributedTitle(.init(string: "Forgot your password?", attributes: [NSAttributedString.Key.font :
                                                                                    UIFont.systemFont(ofSize: 17,weight: .semibold)]), for: .normal)
        return btn
    }()
    override func configureLayout() {
//        view.addSubview(tempBtn)
        [idInputView,pwInputView,pwInputView,loginBtn,forgotBtn].forEach{view.addSubview($0)}
    }
    override func configureConstraints() {
        print("actioned!!")
        idInputView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide )
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(66)
        }
        pwInputView.snp.makeConstraints { make in
            make.top.equalTo(idInputView.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(66)
        }
        loginBtn.snp.makeConstraints { make in
            make.top.equalTo(pwInputView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }
        forgotBtn.snp.makeConstraints { make in
            make.top.equalTo(loginBtn.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
    }
    override func configureNavigation() {
        self.navigationItem.leftBarButtonItem = .init(systemItem: .cancel)
        self.navigationItem.leftBarButtonItem?.rx.tap.bind(with: self) { owner, _ in
            owner.closeAction()
        }.disposed(by: disposeBag)
    }
    override func configureView() {
        view.backgroundColor = .systemBackground
        tempBtn.setTitle("Hello World!!", for: .normal)
        tempBtn.setTitleColor(.systemBackground, for: .normal)
        tempBtn.tintColor = .systemBlue
        idInputView.bindings = .init(text:"", placeholder: "Enter your email", inputInfo: "Email")
        idInputView.bindings?.text.bind(with: self) { owner, text in
            print(text)
        }.disposed(by: disposeBag)
        pwInputView.bindings = .init(text: "", placeholder: "Enter your password", inputInfo: "Password")
    }
}



