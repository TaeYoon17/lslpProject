//
//  UINavigationExtention.swift
//  lslpProject
//
//  Created by 김태윤 on 12/20/23.
//

import UIKit
//MARK: -- 커스텀 네비바 스와이프가 가능하게...
extension UINavigationController: ObservableObject, UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
