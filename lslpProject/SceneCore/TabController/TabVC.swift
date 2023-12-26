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
        bindingHiddenTabbar()
        bindingAddTabbar()
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
    // 추가 버튼 present
    func bindingAddTabbar(){
        App.Manager.shared.addAction.subscribe(on: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.changeTabToMiddleTab()
            }.disposed(by: disposeBag)
    }
    // 탭바 숨기기 애니메이션
    func bindingHiddenTabbar(){
        App.Manager.shared.hideTabbar
            .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance)
            .bind(with: self) { owner, isHidden in
                owner.nowVC?.tabBarController?.tabBar.isHidden = isHidden
                UIView.animate(withDuration: 0.3) {
                    if !isHidden{
                        owner.nowVC?.tabBarController?.tabBar.alpha = 1
                    }else{
                        owner.nowVC?.tabBarController?.tabBar.alpha = 0
                    }
                }
        }.disposed(by: disposeBag)
    }
}
fileprivate extension TabVC{
    func createAction(type: App.CreateType){
        guard let nowVC else {return}
        let vc = switch type{
        case .board:
//            CreatingBoardVC()
            BoardCreateVC()
//        case .collage:
//                CreatingPinVC()
        case .pin:
            CreatingPinVC()
        }
        Task{@MainActor in
            let nav = UINavigationController(rootViewController: vc)
            nowVC.present(nav, animated: true)
        }
    }
}
