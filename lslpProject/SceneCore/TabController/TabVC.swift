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
    struct TabbarString{
        let title: String?
        let defaultIcon: String
        let selectedIcon: String
        func getTabbarItem()-> UITabBarItem{
            UITabBarItem(title: title, image: UIImage(systemName: defaultIcon), selectedImage: UIImage(systemName: selectedIcon))
            
        }
    }
    
    override func viewDidLoad() {
        self.tabBar.backgroundColor = .systemBackground
        tabBar.tintColor = .text
        super.viewDidLoad()
        let vc1 = DiscoverVC()
        vc1.title = "Today"
        let vc2 = FeedVC()
        vc2.title = "Feed"
        let vc3 = ViewController()
        let vc4 = SearchVC()
        vc4.title = "Search"
        let vc5 = AccountVC()
        vc5.title = "Account"
        let naviControllers = zip([vc1,vc2,vc3,vc4,vc5],
                                  [TabbarString(title: "Discover", defaultIcon: "house", selectedIcon: "house.fill"),
                                   TabbarString(title: "Feed", defaultIcon: "rectangle.stack", selectedIcon: "rectangle.stack.fill"),
                                   TabbarString(title: nil, defaultIcon: "", selectedIcon: ""),
                                   TabbarString(title: "Search", defaultIcon: "magnifyingglass", selectedIcon: "magnifyingglass"),
                                   TabbarString(title: "Account", defaultIcon: "person", selectedIcon: "person.fill")
                                  ]).map{
            $0.0.navigationItem.largeTitleDisplayMode = .always
            let nav = UINavigationController(rootViewController: $0.0)
            nav.tabBarItem = $0.1.getTabbarItem()
            nav.navigationBar.prefersLargeTitles = true
            return nav
        }
        setViewControllers(naviControllers, animated: false)
        middleBtn()
        let createOutput = createVM.transform()
        createOutput.startCreateType.subscribe(with: self){ owner, val in
            owner.createAction(type: val)
        }
    }
    weak var nowVC: UIViewController?
    func middleBtn(){
        let frame = CGRect(x: 0.0, y: 0.0,
                           width: tabBar.frame.width / 5,
                           height: tabBar.frame.height)
        
        let button = UIButton(frame: frame)
        var btnConfig = UIButton.Configuration.plain()
        btnConfig.image = UIImage(systemName: "plus.circle",withConfiguration: UIImage.SymbolConfiguration(pointSize: 24))
        let handler: UIButton.ConfigurationUpdateHandler = { button in // 1
            switch button.state { // 2
            case [.selected, .highlighted]:
                button.configuration?.image = UIImage(systemName: "plus.circle.fill",withConfiguration: UIImage.SymbolConfiguration(pointSize: 24))
            case .selected,.highlighted:
                button.configuration?.image = UIImage(systemName: "plus.circle.fill",withConfiguration: UIImage.SymbolConfiguration(pointSize: 24))
            default:
                button.configuration?.image = UIImage(systemName: "plus.circle",withConfiguration: UIImage.SymbolConfiguration(pointSize: 24))
            }
        }
        button.configurationUpdateHandler = handler
        button.backgroundColor = .systemBackground
        button.configuration = btnConfig
        button.center = CGPoint(x: self.tabBar.center.x,
                                y: tabBar.frame.height / 2)
        button.layer.zPosition = 2
        button.addTarget(self, action: #selector(changeTabToMiddleTab), for: UIControl.Event.touchUpInside)
        self.tabBar.addSubview(button)
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
        switch type{
        case .board: break
        case .collage: break
        case .pin:
        }
    }
}
