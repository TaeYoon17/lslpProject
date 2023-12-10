//
//  BoardTitleView.swift
//  lslpProject
//
//  Created by 김태윤 on 12/9/23.
//

import UIKit
import RxSwift
import RxCocoa
extension CreatingBoardVC{
    final class BoardTitleView: UIStackView{
        weak var vm:CreatingBoardVM!{
            didSet{ binding() }
        }
        func binding(){
            disposeBag = DisposeBag()
            titleField.rx.text.orEmpty.subscribe(on: MainScheduler.instance).bind(to: vm.name).disposed(by: disposeBag)
            vm.name.subscribe(on:MainScheduler.asyncInstance).bind { [weak self] name in
                self?.titleField.attributedText = .init(string:name,attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 21, weight: .semibold)])
            }.disposed(by: disposeBag)
        }
        var disposeBag = DisposeBag()
        let titleLabel = UILabel()
        let titleField = UITextField()
        lazy var arr = [titleLabel,titleField]
        required init(coder: NSCoder) { fatalError("Don't use storyboard") }
        init(vm: CreatingBoardVM) {
            self.vm = vm
            super.init(frame: .zero)
            arr.forEach({addArrangedSubview($0)})
            self.simpleConfiguration()
            configureView()
            binding()
        }
        func configureView(){
            titleLabel.text = "Board name"
            titleLabel.font = .preferredFont(forTextStyle: .subheadline)
            titleField.attributedPlaceholder = .init(string: "Give your board a title", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 21, weight: .semibold)])
            titleField.attributedText = .init(string:"",attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 21, weight: .semibold)])
        }
        func configureConstraints(){
            arr.forEach{ view in
                view.snp.makeConstraints { make in
                    make.width.equalToSuperview()
                }
            }
        }
    }
}
