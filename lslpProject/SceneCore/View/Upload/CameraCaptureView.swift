//
//  CameraCaptureVC.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/21.
//

import SnapKit
import UIKit
final class CameraCaptureVC: BaseVC{
    weak var vm: CameraCaptureVM!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemMint
        let label = UILabel()
        label.text = "CameraCaptureVC"
        view.addSubview(label)
        label.textColor = UIColor.text
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
final class CameraCaptureView: BaseView{
    weak var vm: CameraCaptureVM!
    override func configureView() {
        self.backgroundColor = .systemOrange
    }
    override func configureLayout() {
        
    }
    override func configureConstraints() {
        
    }
}
