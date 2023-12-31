//
//  PinCreatingBottomView+DiffableDataSource.swift
//  lslpProject
//
//  Created by 김태윤 on 12/1/23.
//

import UIKit
import SnapKit
import RxSwift
extension PinCreatingBottomView{
    final class BottomDataSource:UICollectionViewDiffableDataSource<String,AlbumItem.ID>{
        weak var vm: CreatingPinVM!
        var disposeBag = DisposeBag()
        init(vm: CreatingPinVM,collectionView: UICollectionView, cellProvider: @escaping UICollectionViewDiffableDataSource<String, AlbumItem.ID>.CellProvider){
            super.init(collectionView: collectionView, cellProvider: cellProvider)
            self.vm = vm
            vm.selectedAlbums.bind(with: self) { owner, album in
                let ids = album.map({$0.id})
                owner.resetSnapshot(albumIDs: ids)
            }.disposed(by: disposeBag)
        }
        @MainActor func resetSnapshot(albumIDs:[AlbumItem.ID]){
            var snapshot = NSDiffableDataSourceSnapshot<String,AlbumItem.ID>()
            snapshot.appendSections(["hello"])
            snapshot.appendItems(albumIDs)
            Task{@MainActor in
                if albumIDs.isEmpty{
                    try await Task.sleep(for: .seconds(0.66))
                }
                await apply(snapshot,animatingDifferences: true)
            }
        }
    }
    var cellReigistration: UICollectionView.CellRegistration<BottomImageCell,AlbumItem.ID>{
        UICollectionView.CellRegistration {[weak self] cell, indexPath, itemIdentifier in
            guard let self else {return}
            guard let item = vm.images.fetchByID(itemIdentifier) else {return}
            Task{[weak self] in
                guard let self else {return}
                await vm.photoCollection.cache.requestImage(for: item.photoAsset, targetSize: .init(width: 360, height: 360)) { completion in
                    if let image = completion?.image{
                        cell.thumbnailImage = image
                    }else{
                        print("이미지 가져오기 오류")
                    }
                }
            }
        }
    }
}
