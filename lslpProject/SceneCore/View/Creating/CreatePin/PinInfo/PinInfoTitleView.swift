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
    let imageView = UIImageView(image: .init(named: "picture_demo"))
    let limitedLabel: UILabel = .init()
    init(vm: CreatingPinInfoVM!) {
        self.vm = vm
        super.init(frame: .zero)
        self.addArrangedSubview(imageView)
        self.addArrangedSubview(label)
        self.addArrangedSubview(textField)
        self.addSubview(limitedLabel)
        label.text = "Title"
        textField.placeholder = "Enter a title"
        limitedLabel.text = "1 / 100"
        limitedLabel.font = .preferredFont(forTextStyle: .footnote)
        self.axis = .vertical
        self.distribution = .fill
        self.alignment = .center
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints { make in
            make.height.equalTo(180)
        }
        label.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        textField.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        limitedLabel.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom)
            make.leading.equalTo(textField)
        }
    }
    required init(coder: NSCoder) {
        fatalError("Don't use storyboard")
    }
}
