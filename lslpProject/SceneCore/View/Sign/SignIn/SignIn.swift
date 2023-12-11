//
//  SignIn.swift
//  lslpProject
//
//  Created by 김태윤 on 12/11/23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
class SignInVC: BaseVC{
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        [idInputView,pwInputView,loginBtn,forgotBtn].forEach{view.addSubview($0)}
    }
    override func configureConstraints() {
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
