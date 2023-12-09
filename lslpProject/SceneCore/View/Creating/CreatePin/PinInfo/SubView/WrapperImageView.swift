//
//  WrapperImageView.swift
//  lslpProject
//
//  Created by 김태윤 on 12/9/23.
//

import UIKit
final class WrapperImageView: BaseView{
    var image:UIImage?{
        didSet{
            guard let image else {return}
            imageView.image = image
            let size = image.size
            let ratio = size.width / size.height
            imageView.snp.makeConstraints { make in
                make.width.equalTo(imageView.snp.height).multipliedBy(ratio)
            }
        }
    }
    private let imageView = UIImageView()
    override func configureView() {
        Task{@MainActor in
            await MainActor.run {
                self.imageView.layer.cornerRadius = 16
                self.imageView.layer.cornerCurve = .circular
                self.imageView.clipsToBounds = true
            }
        }
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .systemBlue
    }
    override func configureLayout() {
        addSubview(imageView)
    }
    override func configureConstraints() {
        imageView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.center.equalToSuperview()
            make.width.equalTo(imageView.snp.height)
        }
    }
    convenience init(image:UIImage?){
        self.init()
        self.image = image
    }
}
