//
//  CreatingPin+ItemCell.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

extension CreatingPinVC{
    final class MainItemCell: UICollectionViewCell{
        var albumItem: AlbumItem?{
            didSet{
                guard let albumItem else {return}
                imageView.image = UIImage(named: albumItem.albumID)
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
        let imageView = UIImageView()
        let selectedLabel = UILabel()
        var maskLayer = CALayer()
        override init(frame: CGRect) {
            super.init(frame: .zero)
            contentView.addSubview(imageView)
            contentView.addSubview(selectedLabel)
            imageView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            selectedLabel.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
            maskLayer.backgroundColor = UIColor.black.withAlphaComponent(0.66).cgColor
            Task{
                maskLayer.frame = self.bounds
            }
            selectedLabel.font = .systemFont(ofSize: 18, weight: .heavy)
        }
        required init?(coder: NSCoder) {
            fatalError("Don't use storyboard")
        }
    }
}
