//
//  AccountVC.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/20.
//

import UIKit
import SnapKit
import SwiftUI
final class ProfileVC: UIHostingController<ProfileView>{
    init() {
        super.init(rootView: ProfileView())
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("Don't use storyboard")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
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



#Preview {
    ProfileView()
}


