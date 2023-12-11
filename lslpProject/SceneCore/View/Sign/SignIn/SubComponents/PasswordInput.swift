//
//  PasswordInput.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/27.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
final class PasswordInput:UIView{
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
    let hiddenToggler:PublishSubject<Void> = PublishSubject()
    var disposeBag = DisposeBag()
    private let textField = UITextField()
    private let inputInfoLabel = UILabel()
    private lazy var toggleButton = {
        let btn = UIButton()
        var config = UIButton.Configuration.plain()
        config.cornerStyle = .capsule
        config.baseForegroundColor = .lightGray
        config.image = UIImage(systemName: "eye.fill")
        btn.configuration = config
        return btn
    }()
    private var isToggle = true
    init(){
        super.init(frame: .zero)
        addSubview(inputInfoLabel)
        addSubview(textField)
        addSubview(toggleButton)
        inputInfoLabel.font = .systemFont(ofSize: 16, weight: .regular)
        inputInfoLabel.textColor = .text
        inputInfoLabel.textAlignment = .left
        textField.font = .systemFont(ofSize: 28, weight: .bold)
        inputInfoLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalToSuperview()
        }
        textField.tintColor = .systemGreen
        textField.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(inputInfoLabel.snp.bottom)
            make.bottom.equalToSuperview()
        }
        toggleButton.snp.makeConstraints { make in
            make.centerY.equalTo(textField)
            make.trailing.equalToSuperview().inset(4)
            make.leading.equalTo(textField.snp.trailing).inset(-4)
        }
        toggleButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        toggleButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        textField.textContentType = .password
        textField.isSecureTextEntry = isToggle
        toggleButton.addAction(.init(handler: { [weak self] _ in
            self?.isToggle.toggle()
            
            self?.textField.isSecureTextEntry = self!.isToggle
            self?.toggleButton.configuration?.baseForegroundColor = (self?.isToggle ?? true) ?  .lightGray : UIColor.text
            
        }), for: .touchUpInside)
    }
    required init?(coder: NSCoder) {
        fatalError("Don't use Storyboard")
    }
}
