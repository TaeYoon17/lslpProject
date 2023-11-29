//
//  GridViewCell.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/29.
//

import UIKit
class GridViewCell: UICollectionViewCell {
    
    var imageView: UIImageView!
    var livePhotoBadgeImageView: UIImageView!
    
    var representedAssetIdentifier: String!
    
    var thumbnailImage: UIImage! {
        didSet {
            imageView.image = thumbnailImage
        }
    }
    var livePhotoBadgeImage: UIImage! {
        didSet {
            livePhotoBadgeImageView.image = livePhotoBadgeImage
        }
    }
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    required init?(coder: NSCoder) {
        fatalError("Don't use storyboard")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        livePhotoBadgeImageView.image = nil
    }
}
