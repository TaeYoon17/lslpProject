//
//  EmailEnterCell.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/27.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class EmailEnterCell: UICollectionViewCell{
    var disposeBag = DisposeBag()
    let titleLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20,weight: .bold)
        return label
    }()
    let inputField = {
        let field = UITextField(frame: .zero)
        field.placeholder = "Enter your email address"
        field.borderStyle = .roundedRect
        field.inputAccessoryView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: 52))
        return field
    }()
    var nextBtn = LogInBtn(text: "Next", textColor: .white, bgColor: .systemGreen, holderColor: .systemGray5, holderBgColor: .lightGray)
    init(){
        super.init(frame: .zero)
        [titleLabel,inputField].forEach { contentView.addSubview($0) }
        inputField.inputAccessoryView?.addSubview(nextBtn)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(8)
        }
        inputField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-8)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }
        nextBtn.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }
        titleLabel.text = "What's your email?"
        inputField.tintColor = .systemGreen
        inputField.rx.text.orEmpty.map { !$0.isEmpty }
            .bind(to: nextBtn.isAvailableLogIn).disposed(by: disposeBag)
    }
    required init?(coder: NSCoder) {
        fatalError("Don't use storyboard")
    }
}
