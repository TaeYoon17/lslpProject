//
//  CreatePin+CollectionView.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

extension CreatingPinVC{
    var layout: UICollectionViewLayout{
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1 / 4), heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1 / 4)), subitems: [item,item,item,item])
        group.interItemSpacing = .fixed(2)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 2
        section.contentInsets = .init(top: 2, leading: 2, bottom: 2, trailing: 2)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    func configureCollectionView(){
        self.collectionView.register(MainItemCell.self, forCellWithReuseIdentifier: "BasicCell")
    }
}
