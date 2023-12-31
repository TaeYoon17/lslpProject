//
//  AlbumNaviTitileButton.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
final class AlbumNaviTitileButton: UIButton{
    let isTappedSubject = BehaviorSubject(value: false)
    let isTappedAction = PublishSubject<Bool>()
    let name = PublishSubject<String>()
    private var disposeBag = DisposeBag()
    let image = UIImage(systemName: "chevron.down",withConfiguration: UIImage.SymbolConfiguration(font: UIFont.boldSystemFont(ofSize: 8)))
    init(){
        super.init(frame: .zero)
        var config = UIButton.Configuration.plain()
        config.imagePlacement = .trailing
        config.imagePadding = 4
        config.attributedTitle = .init("All Photos", attributes: .init([NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 17)]))
        self.tintColor = .text
        config.image = image
        config.baseBackgroundColor = .text
        self.configuration = config
        isTappedSubject.subscribe(on: MainScheduler.asyncInstance).bind(with: self) { owner, val in
            Task{@MainActor in
                UIView.animate(withDuration: 0.3, delay: 0) {
                    if val{
                        let transform = CGAffineTransform(rotationAngle: .pi)
                        owner.imageView?.transform = transform
                    }else{
                        let transform = CGAffineTransform(rotationAngle: 0)
                        owner.imageView?.transform = transform
                    }
                }
            }
        }.disposed(by: disposeBag)
        name.subscribe(on: MainScheduler.asyncInstance).bind(with: self) { owner, name in
            self.configuration?.attributedTitle = .init(name, attributes: .init([NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 17)]))
        }.disposed(by: disposeBag)
        self.rx.tap.bind(with: self) { owner, _ in
            var val = try! owner.isTappedSubject.value()
            val.toggle()
            owner.isTappedAction.onNext(val)
        }.disposed(by: disposeBag)
    }
    required init?(coder: NSCoder) {
        fatalError("Don't use storyboard")
    }
}
