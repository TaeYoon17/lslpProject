//
//  OptionEnterVC.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/28.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
final class OptionEnterVC: BaseVC{
    weak var vm: SignUpVM!
    override func viewDidLoad() {
        super.viewDidLoad()
        prevBtn.rx.tap.bind(to: vm.prevTapped).disposed(by: disposeBag)
        completedBtn.rx.tap.bind(to: vm.completedTapped).disposed(by: disposeBag)
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
    let phoneNumberInputView = PhoneNumberInputView()
    let birthdayInput = BirthDayInputView()
    let completedBtn = OnboardingBtn(text: "Completed", textColor: .white, bgColor: .systemGreen)
    let prevBtn = OnboardingBtn(text: "Prev", textColor: .white, bgColor: .systemGreen)
    lazy var stView = {
        let st = UIStackView(arrangedSubviews: [prevBtn,completedBtn])
        st.axis = .horizontal
        st.alignment = .fill
        st.spacing = 8
        st.distribution = .fillEqually
        return st
    }()
    override func configureLayout() {
        [titleLabel,phoneNumberInputView,birthdayInput,stView].forEach { view.addSubview($0) }
    }
    override func configureNavigation() {
        
    }
    override func configureConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(8)
        }
        
        phoneNumberInputView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-8)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(60)
        }
        birthdayInput.snp.makeConstraints { make in
            make.top.equalTo(phoneNumberInputView.snp.bottom).inset(-8)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(360)
        }
        stView.snp.remakeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
    }
    override func configureView() {
        titleLabel.text = "Additional Information"
        inputField.tintColor = .systemGreen
    }
}
final class PhoneNumberInputView: BaseView{
    private let label = UILabel()
    private let first = UITextField()
    private let middle = UITextField()
    private let last = UITextField()
    lazy var stView = {
        let st = UIStackView(arrangedSubviews: [first,middle,last])
        st.axis = .horizontal
        st.distribution = .fillProportionally
        st.spacing = 4
        return st
    }()
    
    override func configureLayout() {
        self.addSubview(label)
        self.addSubview(stView)
        
    }
    override func configureConstraints() {
        label.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        stView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(label.snp.bottom)
        }
    }
    override func configureView() {
        label.text = "Phone Number"
    }
}
final class BirthDayInputView: BaseView{
    let label = UILabel()
    let picker = UIDatePicker()
    override func configureLayout() {
        [label,picker].forEach { addSubview($0) }
    }
    override func configureConstraints() {
        label.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        picker.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom)
            make.horizontalEdges.equalToSuperview()
        }
    }
    override func configureView() {
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = .current
        label.text = "Birthday"
    }
}
