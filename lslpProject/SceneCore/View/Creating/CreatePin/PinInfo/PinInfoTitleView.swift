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
        didSet{
            binding()
            vm.images
        }
    }
    func binding(){
        disposeBag = DisposeBag()
        vm.title.bind(with: self) { owner,value in
            owner.titleField.attributedText = .init(string: value, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 21, weight: .semibold)])
        }.disposed(by: disposeBag)
        titleField.rx.text.orEmpty.bind(to: vm.title).disposed(by: disposeBag)
        titleField.rx.text.orEmpty.map{"\($0.count) / 48"}.bind(to: limitedLabel.rx.text).disposed(by: disposeBag)
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
        self.titleField.tintColor = .systemGreen
        configureConstraints()
        configureView()
        binding()
        titleField.clearButtonMode = .whileEditing
        self.titleField.delegate = self
        self.titleField.inputAccessoryView = AccessoryView(textField: titleField)
    }
    required init(coder: NSCoder) {
        fatalError("Don't use storyboard")
    }
    deinit{
        print("PinInfoTitleView Deinit!!")
        imageView.timer?.invalidate()
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
        
        limitedLabel.text = "\(0) / 48"
        limitedLabel.font = .preferredFont(forTextStyle: .footnote)
        Task{@MainActor in
            if let asset = vm.images.first{
                imageView.image = try await vm.imageCache.requestImage(for: asset)
            }
        }
        Task{[weak self] in
            guard let self else {return }
            var images:[UIImage] = []
            for asset in vm.images{
                let img = try await vm.imageCache.requestImage(for: asset)
                images.append(img)
            }
            await MainActor.run {[weak self] in
                self?.imageView.images = images
            }
        }
    }
}
//MARK: -- 텍스트 글자 수
extension PinInfoTitleView:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // get the current text, or use an empty string if that failed
        let currentText = textField.text ?? ""
        
        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        // make sure the result is under 16 characters
        return updatedText.count <= 48
    }
}
