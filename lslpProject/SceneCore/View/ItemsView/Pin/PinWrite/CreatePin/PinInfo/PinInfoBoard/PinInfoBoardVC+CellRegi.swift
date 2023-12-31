//
//  PinInfoBoardVC+CellRegistartion.swift
//  lslpProject
//
//  Created by 김태윤 on 12/28/23.
//

import UIKit
import RxCocoa
import RxSwift
import SwiftUI
extension PinInfoBoardVC{
    var cellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell,Item>{
        UICollectionView.CellRegistration {[weak self] cell, indexPath, itemIdentifier in
            guard let self else {return}
            var config = cell.defaultContentConfiguration()
            config.text = itemIdentifier.name
            config.textProperties.font = .systemFont(ofSize: 18,weight: .bold)
            config.secondaryText = itemIdentifier.hashTags
            config.secondaryTextProperties.font = .systemFont(ofSize: 14,weight: .semibold)
            config.secondaryTextProperties.color = .systemGray
            cell.accessories = [.checkmark(options: .init(isHidden: !itemIdentifier.check, reservedLayoutWidth: .standard, tintColor: .systemGreen))]
            if let imageData = itemIdentifier.imageData{
                Task{@MainActor in
                    let image = await UIImage(data: imageData)?.byPreparingThumbnail(ofSize: .init(width: 360, height: 360))
                    config.imageProperties.cornerRadius = 8
                    config.image = image
                    config.imageProperties.maximumSize = .init(width: 60, height: 60)
                    cell.contentConfiguration = config
                }
            }
            cell.contentConfiguration = config
        }
    }
    var headerReigstration : UICollectionView.SupplementaryRegistration<UICollectionViewListCell>{
        UICollectionView.SupplementaryRegistration(elementKind: UICollectionView.elementKindSectionHeader) {[weak self] supplementaryView, elementKind, indexPath in
            supplementaryView.contentConfiguration = UIHostingConfiguration{
                Text("My boards").font(.title2.bold()).foregroundStyle(.text).padding(.horizontal,8)
            }
            
        }
    }
    var layout:UICollectionViewLayout{
        var listConfig = UICollectionLayoutListConfiguration(appearance: .plain)
        listConfig.headerMode = .none
        let header : NSCollectionLayoutBoundarySupplementaryItem = .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(28)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        listConfig.showsSeparators = false
        let layout = UICollectionViewCompositionalLayout.list(using: listConfig)
        let layoutConfig = UICollectionViewCompositionalLayoutConfiguration()
        layoutConfig.boundarySupplementaryItems = [header]
        layout.configuration = layoutConfig
        return layout
    }
}
