//
//  VideoUploadVC.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/21.
//

import SnapKit
import UIKit

final class VideoUploadVC:BaseVC{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        let label = UILabel()
        label.text = "VideoUploadVC"
        view.addSubview(label)
        label.textColor = UIColor.text
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

final class VideoUploadView: BaseView{
    weak var vm: VideoUploadVM!
    override func configureView() {
        self.backgroundColor = .systemBlue
    }
    override func configureLayout() {
        
    }
    override func configureConstraints() {
        
    }
}
