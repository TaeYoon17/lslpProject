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
        let vc1 = DiscoverVC()
        vc1.title = "Today"
        let vc3 = ViewController()
        let vc5 = ProfileVC()
        vc5.title = "Account"
        let naviControllers = zip([vc1,vc3,vc5],
                                  [TabbarString(title: "Discover", defaultIcon: "house", selectedIcon: "house.fill"),
                                   TabbarString(title: nil, defaultIcon: "", selectedIcon: ""),
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
                           height: tabBar.frame.width / 5)
        
        let button = UIButton(frame: frame)
        var btnConfig = UIButton.Configuration.plain()
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 32,weight:.semibold)
        let handler: UIButton.ConfigurationUpdateHandler = { button in // 1
            switch button.state { // 2
            case [.selected, .highlighted]:
                button.transform = .init(scaleX: 0.85, y: 0.85)
            case .selected,.highlighted:
                button.transform = .init(scaleX: 0.85, y: 0.85)
            default:
                button.transform = .init(scaleX: 1, y: 1)
                
            }
        }
        
        button.configurationUpdateHandler = handler
        button.tintColor = .label
        button.configuration = btnConfig
        button.configuration?.image = UIImage(systemName: "plus",withConfiguration: symbolConfig)
        button.center = CGPoint(x: self.tabBar.center.x,y: tabBar.frame.height / 2)
        button.layer.zPosition = 2
        button.addTarget(self, action: #selector(changeTabToMiddleTab), for: UIControl.Event.touchUpInside)
        self.tabBar.addSubview(button)
    }
}
