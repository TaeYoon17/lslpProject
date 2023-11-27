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
    var vm = SignUpVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        let output = vm.output(.init())
        output.nextTapped.bind { [weak self] _ in
            self?.collectionView.scrollToNextItem(axis: .x)
        }
    }
    lazy var collectionView = UICollectionView(frame: .zero,collectionViewLayout: layout)
//    let dataSource = RxCollectionViewSectionedReloadDataSource
    lazy var pageController = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 1
        pageControl.numberOfPages = 0
        pageControl.currentPageIndicatorTintColor = .text
        pageControl.pageIndicatorTintColor = .systemGreen
        pageControl.backgroundStyle = .minimal
        pageControl.subviews.forEach { $0.transform = CGAffineTransform(scaleX: 1.4, y: 1.4) }
        return pageControl
    }()
    
    override func configureLayout() {
        view.addSubview(collectionView)
    }
    override func configureConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    override func configureView() {
        configureCollectionView()
        
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
extension SignUpVC{
    var layout: UICollectionViewLayout{
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.visibleItemsInvalidationHandler = { [weak self] ( visibleItems, offset, env) in
            guard let indexPath = visibleItems.last?.indexPath else {return}
            self?.vm.pageNumber.onNext(indexPath.row)
        }
        let layout = UICollectionViewCompositionalLayout(section: section)
        var layoutConfig = UICollectionViewCompositionalLayoutConfiguration()
        layoutConfig.scrollDirection = .horizontal
        layout.configuration = layoutConfig
        return layout
        
    }
    func configureCollectionView(){
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.isScrollEnabled = false
    }
}
