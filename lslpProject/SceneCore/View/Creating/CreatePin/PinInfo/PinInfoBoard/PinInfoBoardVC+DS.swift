//
//  PinInfoBoardVC+DS.swift
//  lslpProject
//
//  Created by 김태윤 on 12/9/23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

extension PinInfoBoardVC{
    final class DataSource: UICollectionViewDiffableDataSource<String,Board>{
        override init(collectionView: UICollectionView, cellProvider: @escaping UICollectionViewDiffableDataSource<String, Board>.CellProvider) {
            super.init(collectionView: collectionView, cellProvider: cellProvider)
            var snapshot = NSDiffableDataSourceSnapshot<String,Board>()
            snapshot.appendSections(["wow"])
            snapshot.appendItems([.init(name: "hello", pinnedImage: ["lgWin"]),.init(name: "hello", pinnedImage: ["macOS"])])
            apply(snapshot,animatingDifferences: true)
        }
    }
}
