//
//  TempAlbumVC+CollectionView.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/29.
//

import UIKit
import SnapKit
extension CreatingPinVC{
    var layout: UICollectionViewLayout{
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1 / 4), heightDimension: .fractionalHeight(1)))
        item.contentInsets = .init(top: 0, leading: 1, bottom: 0, trailing: 1)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1 / 4)), subitems: [item,item,item,item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 2
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    func configureCollectionView(){
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.prefetchDataSource = self
        let cellReigi = gridCellRegistration
        dataSource = .init(vm:vm,collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            collectionView.dequeueConfiguredReusableCell(using: cellReigi, for: indexPath, item: itemIdentifier)
        })
    }
    var gridCellRegistration: UICollectionView.CellRegistration<CreatingPinMainCell,PhotoAsset.ID>{
        UICollectionView.CellRegistration {[weak self] cell, indexPath, itemIdentifier in
            Task{[weak self] in
                guard let self else {return}
                guard let item = vm.images.fetchByID(itemIdentifier) else {return}
                cell.albumItem = item
                await self.vm.photoCollection.cache.requestImage(for: item.photoAsset, targetSize: .init(width: 360, height: 360)) { completion in
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
extension CreatingPinVC:UICollectionViewDelegate,UICollectionViewDataSourcePrefetching{
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            guard let itemIdentifier = dataSource.itemIdentifier(for: indexPath) else {return}
            guard let item = vm.images.fetchByID(itemIdentifier) else {return}
            Task{
                await self.vm.photoCollection.cache.startCaching(for: [item.photoAsset], targetSize: .init(width: 360, height: 360))
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let itemIdentifier = dataSource.itemIdentifier(for: indexPath) else {return}
        guard let item = vm.images.fetchByID(itemIdentifier) else {return}
        Task{
            await self.vm.photoCollection.cache.stopCaching(for:[item.photoAsset],targetSize:.init(width: 360, height: 360))
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let itemIdentifier = dataSource.itemIdentifier(for: indexPath) else {return}
        guard let item = vm.images.fetchByID(itemIdentifier) else {return}
        vm.toggleCheckItem(item)
    }
}
