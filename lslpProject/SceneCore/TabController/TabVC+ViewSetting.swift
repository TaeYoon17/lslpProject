//
//  TabVC+ViewSetting.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/23.
//

import Foundation
import UIKit
import SwiftUI
extension TabVC{
    func setTabItems(){
        super.viewDidLoad()
//        let vc1 = DiscoverVC()
        let vc1 = DiscoverVC()
        vc1.title = "Today"
//        UIHostingController(rootView: DiscoverView())
        let vc2 = FeedVC()
        vc2.title = "Feed"
        let vc3 = ViewController()
        let vc4 = SearchVC()
        vc4.title = "Search"
        let vc5 = ProfileVC()
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
    }
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
}
