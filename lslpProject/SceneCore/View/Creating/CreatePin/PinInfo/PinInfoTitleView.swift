//
//  PinInfoTitleView.swift
//  lslpProject
//
//  Created by 김태윤 on 12/1/23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
final class PinInfoTitleView: UIStackView{
    var disposeBag = DisposeBag()
    weak var vm: CreatingPinInfoVM!{
        didSet{ binding() }
    }
    func binding(){
        vm.title.bind(with: self) { owner,value in
            owner.titleField.attributedText = .init(string: value, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 21, weight: .semibold)])
        }.disposed(by: disposeBag)
        titleField.rx.text.orEmpty.bind(to: vm.title).disposed(by: disposeBag)
    }
    private let titleField = UITextField()
    private lazy var imageView = WrapperImageView()
    let limitedLabel: UILabel = .init()
    let titleLabel: UILabel = .init()
    init(vm: CreatingPinInfoVM!) {
        self.vm = vm
        super.init(frame: .zero)
        let arr = [imageView,titleLabel,titleField]
        arr.forEach({addArrangedSubview($0)})
        self.addSubview(limitedLabel)
        self.axis = .vertical
        self.distribution = .fill
        self.alignment = .center
        self.spacing = 4
        configureConstraints()
        configureView()
        binding()
    }
    required init(coder: NSCoder) {
        fatalError("Don't use storyboard")
    }
}

extension PinInfoTitleView{
    func configureConstraints(){
        imageView.snp.makeConstraints { make in
            make.height.equalTo(180)
            make.width.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        titleField.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        limitedLabel.snp.makeConstraints { make in
            make.top.equalTo(titleField.snp.bottom).offset(2)
            make.leading.equalTo(titleField)
        }
    }
    func configureView(){
        titleLabel.text = "Title"
        titleLabel.font = .preferredFont(forTextStyle: .subheadline)
        titleField.attributedPlaceholder = .init(string: "Enter a title", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 21, weight: .semibold)])
        limitedLabel.text = "1 / 100"
        limitedLabel.font = .preferredFont(forTextStyle: .footnote)
        Task{@MainActor in
            if let asset = vm.images.last{
                imageView.image = try await vm.imageCache.requestImage(for: asset)
            }
        }
    }
}
