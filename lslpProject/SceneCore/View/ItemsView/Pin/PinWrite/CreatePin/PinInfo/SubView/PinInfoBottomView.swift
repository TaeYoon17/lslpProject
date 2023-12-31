//
//  PinInfoBottomView.swift
//  lslpProject
//
//  Created by 김태윤 on 12/8/23.
//

import UIKit
import RxSwift
import RxCocoa
extension PinInfoVC{
    final class BottomView: BaseView{
        weak var vm: CreatingPinInfoVM!{
            didSet{
                disposeBag = DisposeBag()
                btn.rx.tap.bind(with: self) { owner, _ in
//                owner.vm.upload()
                }.disposed(by: disposeBag)
                vm.isCreateAble.bind(to: btn.rx.isEnabled).disposed(by: disposeBag)
            }
        }
        private var disposeBag = DisposeBag()
        let btn = {
            let btn = UIButton()
            var config = UIButton.Configuration.plain()
            config.contentInsets = .init(top: 12, leading: 12, bottom: 12, trailing: 12)
            config.attributedTitle = .init("Create", attributes: .init([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .semibold)]))
            config.cornerStyle = .capsule
            config.baseBackgroundColor = .systemGreen
            config.background.backgroundColor = .systemGreen
            config.baseForegroundColor = .white
            btn.configuration = config
            return btn
        }()
        override func configureView() {
            let anim = btn.animationSnapshot.scaleEffect(ratio: 0.95)
            do{
                try btn.apply(animationSnapshot: anim)
            }catch{
                print(error)
            }
        }
        override func configureLayout() {
            addSubview(btn)
        }
        override func configureConstraints() {
            btn.snp.makeConstraints { make in
                make.trailing.equalToSuperview().inset(16.5)
                make.centerY.equalToSuperview()
            }
        }
    }
}
