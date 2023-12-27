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
            snapshot.appendItems([Board(),Board()])
            apply(snapshot,animatingDifferences: true)
        }
    }
}
