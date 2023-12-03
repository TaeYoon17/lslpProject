//
//  PinInfoListCell.swift
//  lslpProject
//
//  Created by 김태윤 on 12/2/23.
//

import Foundation
import UIKit
extension UIListContentView{
    static func getPinInfoListCell(text:String,label:UILabel? = nil)->UIListContentView{
        var config = UIListContentConfiguration.valueCell()
        config.imageToTextPadding = 0
        config.attributedText = .init(string: text, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 17)])
        config.directionalLayoutMargins = .init(top: 2, leading: 0, bottom: 2, trailing: 0)
        let view = UIListContentView( configuration: config)
        let imageView = UIImageView(image: .init(systemName: "chevron.right",withConfiguration: UIImage.SymbolConfiguration(font: .boldSystemFont(ofSize: 16))))
        imageView.tintColor = .text
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
        }
        if let label{
            view.addSubview(label)
            label.textColor = .gray
            label.font = .systemFont(ofSize: 15)
            label.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.trailing.equalTo(imageView.snp.leading).inset(-8)
            }
        }
        return view
    }
}
