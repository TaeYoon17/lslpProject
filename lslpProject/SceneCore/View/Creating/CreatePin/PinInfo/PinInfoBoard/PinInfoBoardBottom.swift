//
//  PinInfoBoardBottom.swift
//  lslpProject
//
//  Created by 김태윤 on 12/9/23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
extension PinInfoBoardVC{
    final class PinInfoBoardBottom: BaseView{
        var tap : ControlEvent<Void>!
        override func binding() {
            self.tap = btn.rx.tap
        }
        let btn = {
            let btn = UIButton()
            var config = UIButton.Configuration.plain()
            config.image = UIImage(systemName: "plus.circle.fill",withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 18, weight: .bold)))
            config.attributedTitle = .init("Create board", attributes: .init([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20, weight: .bold)]))
            config.imagePlacement = .leading
            config.imagePadding = 4
            btn.configuration = config
            let snapshot = btn.animationSnapshot.scaleEffect(ratio: 0.95)
            do{
                try btn.apply(animationSnapshot: snapshot)
            }catch{
                print("hello")
            }
            btn.tintColor = .systemGreen
            return btn
        }()
        override func configureLayout() {
            addSubview(btn)
        }
        override func configureConstraints() {
            btn.snp.makeConstraints { make in
                make.leading.equalToSuperview().inset(8)
                make.centerY.equalToSuperview()
            }
        }
        override func configureView() {
        }
    }
}
