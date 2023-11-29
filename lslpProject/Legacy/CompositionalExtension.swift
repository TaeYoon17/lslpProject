//
//  CompositionalExtension.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/18.
//

import UIKit

extension DiscoverVC{
    var layout:UICollectionViewLayout{
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(2), heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .estimated(128), heightDimension: .fractionalHeight(1)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        var layoutConfig = UICollectionViewCompositionalLayoutConfiguration()
        layoutConfig.scrollDirection = .horizontal
        layout.configuration = layoutConfig
        
        return layout
    }
}
