//
//  PinInfoTitleView.swift
//  lslpProject
//
//  Created by 김태윤 on 12/1/23.
//

import UIKit
import SnapKit

final class PinInfoTitleView: UIStackView{
    weak var vm: CreatingPinInfoVM!
    let label: UILabel = .init()
    let textField = UITextField()
    lazy var imageView = WrapperImageView()
    let limitedLabel: UILabel = .init()
    init(vm: CreatingPinInfoVM!) {
        self.vm = vm
        super.init(frame: .zero)
        let arr = [imageView,label,textField]
        arr.forEach({addArrangedSubview($0)})
        self.addSubview(limitedLabel)
        label.text = "Title"
        label.font = .preferredFont(forTextStyle: .subheadline)
        textField.attributedPlaceholder = .init(string: "Enter a title", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 21, weight: .semibold)])
        limitedLabel.text = "1 / 100"
        limitedLabel.font = .preferredFont(forTextStyle: .footnote)
        self.axis = .vertical
        self.distribution = .fill
        self.alignment = .center
        self.spacing = 4
        imageView.snp.makeConstraints { make in
            make.height.equalTo(180)
            make.width.equalToSuperview()
        }
        label.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        textField.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        limitedLabel.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(2)
            make.leading.equalTo(textField)
        }
        imageView.image = .init(named: "lgWin")
    }
    required init(coder: NSCoder) {
        fatalError("Don't use storyboard")
    }
}
final class WrapperImageView: BaseView{
    var image:UIImage?{
        didSet{
            guard let image else {return}
            imageView.image = image
        }
    }
    let imageView = UIImageView()
    override func configureView() {
        imageView.contentMode = .scaleAspectFill
        Task{@MainActor in
            await MainActor.run {
                self.imageView.layer.cornerRadius = 16
                self.imageView.layer.cornerCurve = .circular
                self.imageView.clipsToBounds = true
            }
        }
        imageView.backgroundColor = .systemBlue
    }
    override func configureLayout() {
        addSubview(imageView)
    }
    override func configureConstraints() {
        imageView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.center.equalToSuperview()
        }
    }
    convenience init(image:UIImage?){
        self.init()
        self.image = image
    }
}
