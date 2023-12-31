//
//  GridViewCell.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/29.
//

import UIKit
final class CreatingPinMainCell: UICollectionViewCell {
    var albumItem: AlbumItem?{
        didSet{
            guard let albumItem else {return}
            if albumItem.selectedIdx < 0{
                maskLayer.removeFromSuperlayer()
                selectedLabel.text = ""
                selectedLabel.isHidden = true
            }else{
                imageView.layer.addSublayer(maskLayer)
                selectedLabel.text = "\(albumItem.selectedIdx)"
                selectedLabel.isHidden = false
            }
        }
    }
    @MainActor var thumbnailImage: UIImage? {
        didSet {
            Task{@MainActor in
                imageView.image = thumbnailImage
            }
        }
    }
    @MainActor let imageView = UIImageView()
    var representedAssetIdentifier: String?
    let selectedLabel = UILabel()
    var maskLayer = CALayer()
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.addSubview(imageView)
        contentView.addSubview(selectedLabel)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        selectedLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        maskLayer.backgroundColor = UIColor.black.withAlphaComponent(0.2).cgColor
        Task{
            maskLayer.frame = self.bounds
        }
        selectedLabel.font = .systemFont(ofSize: 18, weight: .heavy)
        selectedLabel.textColor = .white
    }
    required init?(coder: NSCoder) {
        fatalError("Don't use storyboard")
    }
    
}
