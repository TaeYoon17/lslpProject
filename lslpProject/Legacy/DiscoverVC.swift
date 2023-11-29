//
//  DiscoverView.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/18.
//

//import UIKit
//import SnapKit
//import RxSwift
//import RxCocoa
//import RxDataSources
//final class DiscoverVC: BaseVC{
//    lazy var topTabView = TopTabViewer(frame: .zero)
//    lazy var pageViewController: UIPageViewController = {
//        let vc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
//        return vc
//    }()
//    lazy var vc1: UIViewController = {
//        let vc = UIViewController()
//        vc.view.backgroundColor = .red
//        return vc
//    }()
//    lazy var vc2: UIViewController = {
//        let vc = UIViewController()
//        vc.view.backgroundColor = .green
//        return vc
//    }()
//
//    lazy var vc3: UIViewController = {
//        let vc = UIViewController()
//        vc.view.backgroundColor = .blue
//        return vc
//    }()
//    lazy var vc4: UIViewController = {
//        let vc = UIViewController()
//        vc.view.backgroundColor = .brown
//        return vc
//    }()
//    lazy var vc5: UIViewController = {
//        let vc = UIViewController()
//        vc.view.backgroundColor = .darkGray
//        return vc
//    }()
//    lazy var vc6: UIViewController = {
//        let vc = UIViewController()
//        vc.view.backgroundColor = .yellow
//        return vc
//    }()
//
//    lazy var dataViewControllers: [UIViewController] = {
//        let res = [vc1, vc2, vc3,vc4,vc5,vc6]
//        res.enumerated().forEach { idx,vc in
//            vc.view.tag = idx
//        }
//        return res
//    }()
//    let nowIdx = BehaviorSubject(value: 0)
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.navigationController?.setNavigationBarHidden(true, animated: false)
//        view.backgroundColor = .systemBackground
//        setupDelegate()
//        configure()
//        
//        if let firstVC = dataViewControllers.first {
//            pageViewController.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
//        }
//        
//        let sections = [
//                TopTabSection(header: "first", items: [
//                       TopTabItem(name: "o", isSelected: false),
//                       TopTabItem(name: "two", isSelected: false),
//                       TopTabItem(name: "threeasdfasdfassadasdfsd", isSelected: false),
//                       TopTabItem(name: "fourrr", isSelected: false),
//                       TopTabItem(name: "fiveeeeeeeeeeeeeee", isSelected: false),
//                       TopTabItem(name: "Hell World!!", isSelected: false),
//                   ])
//               ]
//        let nowIdxDrive = nowIdx.asDriver(onErrorJustReturn: 0)
//        nowIdxDrive.drive(topTabView.tabIndex).disposed(by: disposeBag)
//        topTabView.tabIndex
//            .observe(on: MainScheduler.asyncInstance)
//            .bind {[weak self] val in
//            guard let self else {return}
//            self.setViewcontrollersFromIndex(index: val)
//        }.disposed(by: disposeBag)
//        BehaviorSubject(value: sections)
//            .bind(to: topTabView.subject).disposed(by: disposeBag)
//    }
//
//    private func setupDelegate() {
//        pageViewController.dataSource = self
//        pageViewController.delegate = self
//    }
//
//    private func configure() {
//        view.addSubview(topTabView)
//        addChild(pageViewController)
//        view.addSubview(pageViewController.view)
//
//        topTabView.snp.makeConstraints { make in
//            make.width.top.equalToSuperview()
//            make.height.equalTo(96)
//        }
//
//        pageViewController.view.snp.makeConstraints { make in
//            make.top.equalTo(topTabView.snp.bottom)
//            make.leading.trailing.bottom.equalToSuperview()
//        }
//        pageViewController.didMove(toParent: self)
//    }
//}
//
//extension DiscoverVC: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
//
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
//        guard let index = dataViewControllers.firstIndex(of: viewController) else { return nil }
//        let previousIndex = index - 1
//        if previousIndex < 0 {
//            return nil
//        }
//        return dataViewControllers[previousIndex]
//    }
//
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
//        guard let index = dataViewControllers.firstIndex(of: viewController) else { return nil }
//        let nextIndex = index + 1
//        if nextIndex == dataViewControllers.count {
//            return nil
//        }
//        return dataViewControllers[nextIndex]
//    }
//    // 현재 페이지 로드가 끝났을 때
//    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
//        if completed {
//            let currentViewController = self.pageViewController.viewControllers![0]
//            let currentIdx = currentViewController.view.tag
//            nowIdx.onNext(currentIdx)
//        }
//    }
//    func setViewcontrollersFromIndex(index : Int){
//        if index < 0 && index >= dataViewControllers.count {return }
//        let nowIdx = try! nowIdx.value()
//        let direction: UIPageViewController.NavigationDirection? = if nowIdx < index{ .forward
//        }else if nowIdx > index{ .reverse
//        }else{ nil
//        }
//        guard let direction else {return}
//        pageViewController.setViewControllers([dataViewControllers[index]], direction: direction, animated: true)
//        self.nowIdx.onNext(index)
//    }
//}

