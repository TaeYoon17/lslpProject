//
//  TabVC.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/20.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
final class TabVC: UITabBarController{
    private var createVM = CreatingVM()
    var disposeBag = DisposeBag()
    weak var nowVC: UIViewController?
    struct TabbarString{
        let title: String?
        let defaultIcon: String
        let selectedIcon: String
        func getTabbarItem()-> UITabBarItem{
            UITabBarItem(title: title, image: UIImage(systemName: defaultIcon), selectedImage: UIImage(systemName: selectedIcon))
        }
    }
    deinit{
        print("TabVC는 사라진다구~")
    }
    override func viewDidLoad() {
        self.tabBar.backgroundColor = .systemBackground
        tabBar.tintColor = .text
        setTabItems()
        middleBtn()
        let createOutput = createVM.transform()
        createOutput.startCreateType.subscribe(with: self){ owner, val in
            owner.createAction(type: val)
        }.disposed(by: disposeBag)
    }
    @objc func changeTabToMiddleTab(){
        guard let nowVC else {return}
        let vc = CreatingVC()
        vc.vm = createVM
        let nav = UINavigationController(rootViewController: vc)
        if let presenter = nav.sheetPresentationController{
            presenter.detents = [.custom(resolver: { context in 240 })]
            presenter.preferredCornerRadius = 16
        }
        nowVC.present(nav, animated: true)
    }
    func tabBarDidLoad(vc: UIViewController){
        self.nowVC = vc
    }
}
fileprivate extension TabVC{
    func createAction(type: App.CreateType){
        guard let nowVC else {return}
        let vc = switch type{
        case .board:
            CreatingBoardVC()
        case .collage:
                CreatingPinVC()
        case .pin:
            CreatingPinVC()
        }
        Task{@MainActor in
            let nav = UINavigationController(rootViewController: vc)
            nowVC.present(nav, animated: true)
        }
    }
}
