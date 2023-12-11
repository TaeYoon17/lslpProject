//
//  SignUpVC.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/14.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources
final class SignUpVC: BaseVC{
    let vm = SignUpVM(maxPageNumber: 4)
    lazy var pageViewController: UIPageViewController = {
        let vc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        return vc
    }()
    lazy var emailVC = {
        let vc = EmailEnterVC()
        vc.vm = self.vm
        return vc
    }()
    lazy var pwVC = {
        let vc = PWEnterVC()
        vc.vm = self.vm
        return vc
    }()
    lazy var nickVC = {
        let vc = NickNameVC()
        vc.vm = self.vm
        return vc
    }()
    lazy var optVC = {
        let vc = OptionEnterVC()
        vc.vm = self.vm
        return vc
    }()
    lazy var dataViewControllers: [UIViewController] = {
        let res = [emailVC,pwVC,nickVC,optVC]
        res.enumerated().forEach { $1.view.tag = $0 }
        return res
    }()
    var prevPage = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        let output = vm.output()
        vm.pageNumber.bind(with: self) { owner, val in
            owner.setViewcontrollersFromIndex(index: val)
            owner.pageController.currentPage = val
        }.disposed(by: disposeBag)
        output.signFailed
            .subscribe(on: MainScheduler.asyncInstance)
            .subscribe(with: self){owner,val in
            let alert = UIAlertController(title: val.message, message: nil, preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Back", style: .cancel)
            alert.addAction(cancel)
            owner.present(alert, animated: true)
        }.disposed(by: disposeBag)
        output.signUp
            .subscribe(on: MainScheduler.asyncInstance)
            .bind(with: self) { owner, _ in
            let alert = UIAlertController(title: "It's Success", message: nil, preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Back", style: .cancel)
            alert.addAction(cancel)
            owner.present(alert, animated: true)
        }.disposed(by: disposeBag)
    }
    
    lazy var pageController = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 1
        pageControl.numberOfPages = 4
        pageControl.currentPageIndicatorTintColor = .text
        pageControl.pageIndicatorTintColor = .systemGreen
        pageControl.backgroundStyle = .minimal
        pageControl.subviews.forEach { $0.transform = CGAffineTransform(scaleX: 1.4, y: 1.4) }
        return pageControl
    }()
    
    override func configureLayout() {
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
    }
    override func configureConstraints() {
        pageViewController.view.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    override func configureView() {
        view.backgroundColor = .systemRed
        pageViewController.delegate = self
        pageViewController.dataSource = self
        pageViewController.didMove(toParent: self)
        pageViewController.view.subviews.forEach { view in
            guard let view = view as? UIScrollView else {return}
            view.isScrollEnabled = false
        }
        if let firstVC = dataViewControllers.first {
            pageViewController.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
        
    }
    override func configureNavigation() {
        self.navigationItem.leftBarButtonItem = .init(systemItem: .cancel)
        self.navigationItem.leftBarButtonItem?.tintColor = .text
        guard let leftItem = self.navigationItem.leftBarButtonItem else {return}
        leftItem.rx.tap.bind(with: self) { owner, _ in
            owner.dismiss(animated: true)
        }.disposed(by: disposeBag)
        self.navigationItem.titleView = pageController
    }
}
extension SignUpVC: UIPageViewControllerDataSource,UIPageViewControllerDelegate{
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        nil
    }
    // 현재 페이지 로드가 끝났을 때
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            let currentViewController = self.pageViewController.viewControllers![0]
            let currentIdx = currentViewController.view.tag
            vm.pageNumber.onNext(currentIdx)
        }
    }
    func setViewcontrollersFromIndex(index : Int){
        if index < 0 && index >= dataViewControllers.count {return }
        let nowIdx = try! vm.pageNumber.value()
        let direction: UIPageViewController.NavigationDirection? = if prevPage < index{ .forward
        }else if prevPage > index{ .reverse
        }else{ nil
        }
        guard let direction else {return}
        pageViewController.setViewControllers([dataViewControllers[index]], direction: direction, animated: true)
        prevPage = index
    }
}
