//
//  EmailInput.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/27.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
final class EmailInput:UIView{
    var bindings: TextInputBindings?{
        didSet{
            guard let bindings else {return}
            disposeBag = DisposeBag()
            bindings.text.bind(to: textField.rx.text).disposed(by: disposeBag)
            textField.attributedPlaceholder = .init(string: bindings.placeholder, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 28, weight: .bold),
                                                                                               .foregroundColor: UIColor.systemGray])
            textField.placeholder = bindings.placeholder
            inputInfoLabel.text = bindings.inputInfo
            textField.rx.text.orEmpty.bind(to: bindings.text).disposed(by: disposeBag)
        }
    }
    var disposeBag = DisposeBag()
    private let textField = UITextField()
    private let inputInfoLabel = UILabel()
    init(){
        super.init(frame: .zero)
        addSubview(inputInfoLabel)
        addSubview(textField)
        inputInfoLabel.font = .systemFont(ofSize: 16, weight: .regular)
        inputInfoLabel.textColor = .text
        inputInfoLabel.textAlignment = .left
        textField.font = .systemFont(ofSize: 28, weight: .bold)
        inputInfoLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalToSuperview()
        }
        textField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(inputInfoLabel.snp.bottom)
            make.bottom.equalToSuperview()
        }
        textField.clearButtonMode = .whileEditing
        textField.keyboardType = .emailAddress
        textField.tintColor = .systemGreen
    }
    required init?(coder: NSCoder) {
        fatalError("Don't use Storyboard")
    }
}
