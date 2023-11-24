////
////  TabManTempVC.swift
////  lslpProject
////
////  Created by 김태윤 on 2023/11/19.
////
//
//import Tabman
//import Pageboy
//import UIKit
//final class TabViewController: TabmanViewController {
//    private var viewControllers = [UIViewController(), UIViewController()]
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        self.dataSource = self
//        // Create bar
//        let bar = TMBar.TabBar()
////        bar.layout.interButtonSpacing = 8
//        bar.backgroundView.style = .clear
//        
//        bar.layout.transitionStyle = .snap // Customize
////        bar.indicator.cornerStyle = .rounded
//        bar.indicator.overscrollBehavior = .none
//        bar.layout.contentInset = .init(top: 0, left: 16.5, bottom: 0, right: 16.5)
//        // Add to view
//        addBar(bar, dataSource: self, at: .top)
//    }
//}
//extension TabViewController: PageboyViewControllerDataSource, TMBarDataSource {
//
//    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
//        return viewControllers.count
//    }
//
//    func viewController(for pageboyViewController: PageboyViewController,
//                        at index: PageboyViewController.PageIndex) -> UIViewController? {
//        return viewControllers[index]
//    }
//
//    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
//        return nil
//    }
//
//    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
//        let title = "Page \(index)"
//        return TMBarItem(title: title)
//    }
//}
