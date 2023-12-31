//
//  PinInfoBoardVC.swift
//  lslpProject
//
//  Created by 김태윤 on 12/9/23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
final class PinInfoBoardVC: BaseVC{
    var vm: PinInfoBoardVM!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .systemBackground
        bottomView.tap.bind(with: self) { owner, _ in
            let createBoard = BoardCreateVC()
            owner.present(createBoard, animated: true)
        }.disposed(by: disposeBag)
    }
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    lazy var bottomView = PinInfoBoardBottom()
    var dataSource: DataSource!
    let searchController = UISearchController()
    override func configureLayout() {
        [bottomView,collectionView].forEach{
            view.addSubview($0)
        }
    }
    override func configureConstraints() {
        bottomView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(52)
        }
        collectionView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(bottomView.snp.top)
        }
        bottomView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        bottomView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
    }
    override func configureNavigation() {
        navigationItem.title = "Save To"
        searchController.searchBar.placeholder = "Search"
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.searchController = searchController
        self.navigationController?.navigationBar.tintColor = .text
    }
    override func configureView() {
        view.backgroundColor = .systemBackground
        configureCollectionView()
    }
}
