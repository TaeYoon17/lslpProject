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
    private(set) var output: Output
    private let label = UILabel()
    private let textField = UITextField()
    private let attr = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: .semibold)]
    init(explain:String,placeholder:String){
        self.output = Output(text: textField.rx.text.orEmpty)
        super.init(frame: .zero)
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
    }
    required init(coder: NSCoder) {
        fatalError("Don't use storyboard")
    }
    struct Input{
    }
    struct Output{
        let text: ControlProperty<String>
    }
}
