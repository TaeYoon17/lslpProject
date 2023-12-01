//
//  MethosSwizzleVC.swift
//  lslpProject
//
//  Created by 김태윤 on 12/1/23.
//

import UIKit
final class MethosSwizzleVC: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}
extension UIViewController{
    // 오버라이딩 가능
    class func methodSwizzling(){
        let origin = #selector(viewWillAppear)
        let change = #selector(changeViewWillAppear)
        
        guard let originMethod = class_getInstanceMethod(UIViewController.self, origin),
              let changeMehod = class_getInstanceMethod(UIViewController.self, change) else {
            print("함수를 찾을 수 없음")
            return
        }
        method_exchangeImplementations(originMethod, changeMehod)
    }
    @objc func changeViewWillAppear(){
        // 앱 분석 특정 기능...
    }
}
