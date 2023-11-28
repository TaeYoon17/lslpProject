//
//  RestVC.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/28.
//
import UIKit
import SnapKit
import RxSwift
import RxCocoa
final class NickNameVC: BaseVC{
    weak var vm: SignUpVM!
    override func viewDidLoad() {
        super.viewDidLoad()
        inputField.rx.text.orEmpty.bind(to: vm.nickSubject).disposed(by: disposeBag)
        nextBtn.rx.tap.bind(to: vm.nextTapped).disposed(by: disposeBag)
        prevBtn.rx.tap.bind(to: vm.prevTapped).disposed(by: disposeBag)
    }
    let titleLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20,weight: .bold)
        return label
    }()
    let inputField = {
        let field = UITextField(frame: .zero)
        field.placeholder = "Enter your nickname"
        field.borderStyle = .roundedRect
        field.inputAccessoryView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 52))
        return field
    }()
    let nextBtn = LogInBtn(text: "Next", textColor: .white, bgColor: .systemGreen, holderColor: .systemGray5, holderBgColor: .lightGray)
    let prevBtn = OnboardingBtn(text: "Prev", textColor: .white, bgColor: .systemGreen)
    lazy var stView = {
       let st = UIStackView(arrangedSubviews: [prevBtn,nextBtn])
        st.axis = .horizontal
        st.alignment = .fill
        st.spacing = 8
        st.distribution = .fillEqually
        return st
    }()
    override func configureLayout() {
        [titleLabel,inputField].forEach { view.addSubview($0) }
        inputField.inputAccessoryView?.addSubview(stView)
    }
    override func configureNavigation() {
        
    }
    override func configureConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(8)
        }
        inputField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-8)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }
        stView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }
    }
    override func configureView() {
        titleLabel.text = "Make your nickname!!"
        inputField.tintColor = .systemGreen
        inputField.rx.text.orEmpty.map { !$0.isEmpty }
            .bind(to: nextBtn.isAvailableLogIn).disposed(by: disposeBag)
    }
}
