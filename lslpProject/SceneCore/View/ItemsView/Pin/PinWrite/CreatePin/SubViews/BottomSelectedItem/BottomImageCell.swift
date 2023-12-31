//
//  BottomImageCell.swift
//  lslpProject
//
//  Created by 김태윤 on 12/1/23.
//

import Foundation
import UIKit
final class BottomImageCell: UICollectionViewCell{
    @MainActor var thumbnailImage: UIImage? {
        didSet {
            Task{@MainActor in
                imageView.image = thumbnailImage
            }
        }
    }
    @MainActor let imageView = UIImageView()
    private let btn = {
        let btn = UIButton()
        var config = UIButton.Configuration.plain()
        config.background.visualEffect = UIBlurEffect(style: .systemChromeMaterialDark)
        config.baseForegroundColor = .white
        config.cornerStyle = .capsule
        config.imagePadding = 8
        
        config.image = UIImage(systemName: "xmark",withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 6, weight: .black)))
//        btn.tintColor = .white
        btn.configuration = config
        btn.isUserInteractionEnabled = false
        return btn
    }()
    var representedAssetIdentifier: String?
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.addSubview(imageView)
        contentView.addSubview(btn)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        btn.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(4)
            make.height.width.equalTo(16)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("Don't user storyboard")
    }
}
