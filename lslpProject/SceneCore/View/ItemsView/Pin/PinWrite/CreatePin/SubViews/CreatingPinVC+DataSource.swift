//
//  AlbumVC+DataSource.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/12/01.
//

import UIKit
import RxSwift
extension CreatingPinVC{
    final class DataSource: UICollectionViewDiffableDataSource<String,AlbumItem.ID>{
        weak var vm: CreatingPinVM!
        var disposeBag = DisposeBag()
        init(vm: CreatingPinVM,collectionView: UICollectionView, cellProvider: @escaping UICollectionViewDiffableDataSource<String, AlbumItem.ID>.CellProvider){
            super.init(collectionView: collectionView, cellProvider: cellProvider)
            self.vm = vm
            vm.albums.bind(with: self) { owner, item in
                owner.initSnapshot(albumItems: item.map{$0.id})
            }.disposed(by: disposeBag)
            vm.updatedAlbums.bind(with: self) { owner, item in
                owner.reloadSnapshot(albumItems: item.map{$0.id})
            }.disposed(by: disposeBag)
        }
        @MainActor func initSnapshot(albumItems: [AlbumItem.ID]){
            var snapshot = NSDiffableDataSourceSnapshot<String,PhotoAsset.ID>()
            snapshot.appendSections(["wow"])
            snapshot.appendItems(albumItems)
            apply(snapshot,animatingDifferences: false)
        }
        @MainActor func reloadSnapshot(albumItems: [AlbumItem.ID]){
            var snapshot = self.snapshot()
            snapshot.reconfigureItems(albumItems)
            apply(snapshot,animatingDifferences: false)
        }
    }
}
