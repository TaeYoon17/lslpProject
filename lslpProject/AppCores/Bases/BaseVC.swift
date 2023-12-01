//
//  BaseVC.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/14.
//

import UIKit
import RxSwift
class BaseVC: UIViewController{
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        configureNavigation()
        configureConstraints()
        configureView()
    }
    func configureLayout(){ }
    func configureConstraints(){ }
    func configureView(){ }
    func configureNavigation(){ }
    
    func closeAction(){
        if let navi = navigationController{ navi.popViewController(animated: true) }
        self.dismiss(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let tabBarController else {return}
        self.tabBarController?.tabBar.isHidden = false
        if let tabbarController = self.tabBarController as? TabVC{
            tabbarController.tabBarDidLoad(vc: self)
        }
    }
}
