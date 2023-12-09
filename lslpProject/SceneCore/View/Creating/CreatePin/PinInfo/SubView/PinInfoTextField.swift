//
//  PinInfoTextField.swift
//  lslpProject
//
//  Created by 김태윤 on 12/2/23.
//

import SnapKit
import UIKit
import RxSwift
import RxCocoa
final class PinInfoTextField: UIStackView{
    let text = BehaviorSubject(value: "")
    private let label = UILabel()
    private let textField = UITextField()
    private let attr = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: .semibold)]
    var disposeBag = DisposeBag()
    init(explain:String,placeholder:String,keyboard: UIKeyboardType = .default){
        super.init(frame: .zero)
        textField.rx.text.orEmpty.bind(with: self) { owner, text in
            owner.textField.attributedText = .init(string: text, attributes: owner.attr)
        }.disposed(by: disposeBag)
        textField.rx.text.orEmpty.bind(to: text).disposed(by: disposeBag)
        self.addArrangedSubview(label)
        self.addArrangedSubview(textField)
        self.axis = .vertical
        self.distribution = .fillProportionally
        self.alignment = .fill
        self.spacing = 2
        label.text = explain
        textField.attributedPlaceholder = .init(string: placeholder, attributes: attr)
        textField.tintColor = .systemGreen
        label.font = .systemFont(ofSize: 14, weight: .regular)
        textField.keyboardType = keyboard
    }
    required init(coder: NSCoder) {
        fatalError("Don't use storyboard")
    }

}
