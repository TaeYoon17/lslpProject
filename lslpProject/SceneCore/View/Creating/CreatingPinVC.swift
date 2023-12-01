//
//  TempAlbumVC.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/29.
//

import UIKit
import Photos
import SnapKit
import RxSwift
import RxCocoa
final class CreatingPinVC: BaseVC{
    var vm = AlbumVM()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    lazy var pinCreatingBottomView = PinCreatingBottomView(vm:vm)
    var dataSource: DataSource!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func configureLayout() {
        view.addSubview(collectionView)
        view.addSubview(pinCreatingBottomView)
    }
    override func configureConstraints() {
        pinCreatingBottomView.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(66)
        }
        collectionView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(pinCreatingBottomView.snp.top)
        }
    }
    override func configureNavigation() {
        navigationItem.leftBarButtonItem = .init(systemItem: .cancel)
        let button = AlbumNaviTitileButton()
        navigationItem.titleView = button
        navigationItem.leftBarButtonItem?.rx.tap.bind(with: self) { owner, _ in
            owner.closeAction()
        }.disposed(by: disposeBag)
        button.isTappedSubject.bind(with: self) { owner, isTapped in
            print("isTapped and present Albums")
        }.disposed(by: disposeBag
        )
    }
    
    override func configureView() {
        view.backgroundColor = .systemBackground
        configureCollectionView()
    }
}
final class PinCreatingBottomView: UICollectionView{
    weak var vm: AlbumVM!
    init(vm: AlbumVM){
        super.init(frame: .zero, collectionViewLayout: Self.layout)
        self.vm = vm
    }
    required init?(coder: NSCoder) {
        fatalError("Don't use storyboard")
    }
    
}
extension PinCreatingBottomView{
    static fileprivate var layout: UICollectionViewLayout{
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalHeight(1), heightDimension: .fractionalWidth(1)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
