//
//  PrivacyView.swift
//  lslpProject
//
//  Created by 김태윤 on 12/9/23.
//

import UIKit
import RxSwift
import RxCocoa

extension CreatingBoardVC{
    final class PrivacyView:UIStackView{
        weak var vm:CreatingBoardVM!{
            didSet{ binding() }
        }
        func binding(){
            disposeBag = DisposeBag()
            switcher.rx.isOn.bind(to: vm.isPrivacy).disposed(by: disposeBag)
        }
        var disposeBag = DisposeBag()
        let headLabel = UILabel()
        let titleLabel = UILabel()
        let infoLabel = UILabel()
        let switcher = UISwitch()
        lazy var arr = [headLabel,titleLabel]
        required init(coder: NSCoder) { fatalError("Don't use storyboard") }
        init(vm: CreatingBoardVM) {
            self.vm = vm
            super.init(frame: .zero)
            addSubview(switcher)
            addSubview(infoLabel)
            arr.forEach({addArrangedSubview($0)})
            self.simpleConfiguration()
            configureView()
            configureConstraints()
            binding()
            switcher.onTintColor = .systemGreen
            switcher.preferredStyle = .checkbox
        }
        func configureView(){
            headLabel.text = "Privacy"
            headLabel.font = .preferredFont(forTextStyle: .subheadline)
            titleLabel.text = "Make this board secret"
            titleLabel.font = .boldSystemFont(ofSize: 21)
            infoLabel.text = "Only you and collaborators will see this board"
            switcher.transform = .init(scaleX: 0.85, y: 0.85)
            infoLabel.numberOfLines = 0
        }
        func configureConstraints(){
            arr.forEach{ view in
                view.snp.makeConstraints { make in
                    make.width.equalToSuperview()
                }
            }
            switcher.snp.makeConstraints { make in
                make.trailing.equalToSuperview()
                make.centerY.equalTo(titleLabel)
                make.height.equalTo(32)
            }
            infoLabel.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(4)
                make.leading.equalTo(titleLabel)
                make.trailing.equalTo(switcher.snp.leading).inset(-8)
            }
            switcher.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            switcher.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        }
    }
}
