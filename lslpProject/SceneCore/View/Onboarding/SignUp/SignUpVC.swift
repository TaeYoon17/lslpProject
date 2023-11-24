//
//  SignUpVC.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/14.
//

import UIKit
import SnapKit
import RxSwift
final class SignUpVC: BaseVC{
//    var vm = SignUpVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let leftItem = self.navigationItem.leftBarButtonItem else {return}
        leftItem.rx.tap.bind(with: self) { owner, _ in
            owner.dismiss(animated: true)
        }.disposed(by: disposeBag)
    }
    override func configureNavigation() {
        self.navigationItem.leftBarButtonItem = .init(systemItem: .cancel)
    }
    
}
