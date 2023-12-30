//
//  AlbumSelectorView.swift
//  lslpProject
//
//  Created by 김태윤 on 12/2/23.
//

import SnapKit
import UIKit
import RxSwift
import RxCocoa
final class AlbumSelectorView: UICollectionView{
    weak var vm: CreatingPinVM!
    var diffableDS: AlbumDataSource!
    init(vm: CreatingPinVM){
        super.init(frame: .zero,collectionViewLayout: Self.layout)
        self.vm = vm
        self.delegate = self
        let cellRegi = cellRegistration
        diffableDS = .init(vm: vm, collectionView: self, cellProvider: { collectionView, indexPath, itemIdentifier in
            collectionView.dequeueConfiguredReusableCell(using: cellRegi, for: indexPath, item: itemIdentifier)
        })
    }
    required init?(coder: NSCoder) {
        fatalError("Don't use storyboard")
    }
    deinit{
        print("AlbumSelectorView Deinit!!")
    }
}

extension AlbumSelectorView: UICollectionViewDelegate{
    var cellRegistration:UICollectionView.CellRegistration<UICollectionViewListCell,AlbumModel.ID>{
        .init {[weak self] cell, indexPath, itemIdentifier in
            guard let self else {return}
            guard let item = self.diffableDS.models.fetchByID(itemIdentifier) else {return}
            var config = cell.defaultContentConfiguration()
            config.text = item.name
            config.textProperties.font = .preferredFont(forTextStyle: .headline)
            cell.accessories = [.label(text: "\(item.count) 개")]
            cell.contentConfiguration = config
        }
    }
    static var layout: UICollectionViewLayout{
        var listConfig = UICollectionLayoutListConfiguration(appearance: .plain)
        listConfig.backgroundColor = .systemBackground
        return UICollectionViewCompositionalLayout.list(using: listConfig)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didselectItem!!")
        collectionView.deselectItem(at: indexPath, animated: true)
        
        guard let dataID = diffableDS.itemIdentifier(for: indexPath), let data = self.diffableDS.models.fetchByID(dataID) else {return}
        vm.selectedAlbumModel.onNext(data)
        Task{@MainActor in
            collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            
        }
    }
}
extension AlbumSelectorView{
    final class AlbumDataSource: UICollectionViewDiffableDataSource<String,AlbumModel.ID>{
        weak var vm: CreatingPinVM!
        var models:AnyModelStore<AlbumModel> = .init([])
        var disposeBag = DisposeBag()
        init(vm:CreatingPinVM,collectionView: UICollectionView, cellProvider: @escaping UICollectionViewDiffableDataSource<String, AlbumModel.ID>.CellProvider){
            super.init(collectionView:collectionView , cellProvider: cellProvider)
            vm.albumList.bind(with: self) { owner, model in
                owner.models = .init(model)
                owner.newDataSource(models: model.map{$0.id})
            }.disposed(by: disposeBag)
        }
        private func newDataSource(models :[AlbumModel.ID]){
            var snapshot = NSDiffableDataSourceSnapshot<String,AlbumModel.ID>()
            snapshot.appendSections(["gdgd"])
            snapshot.appendItems(models, toSection: "gdgd")
            apply(snapshot,animatingDifferences: true)
        }
    }
}
