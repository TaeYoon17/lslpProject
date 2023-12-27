//
//  PinInfoBoardVC+CollectionView.swift
//  lslpProject
//
//  Created by 김태윤 on 12/9/23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
extension PinInfoBoardVC{
    func configureCollectionView(){
        collectionView.backgroundColor = .systemRed
        let cellRegi = cellRegistration
        let headerRegi = headerReigstration
        dataSource = .init(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            collectionView.dequeueConfiguredReusableCell(using: cellRegi, for: indexPath, item: itemIdentifier)
        })
        dataSource.supplementaryViewProvider = { collectionView,elementKind,indexPath in
            switch elementKind{
            case UICollectionView.elementKindSectionHeader:
                return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegi, for: indexPath)
            default: return nil
            }
        }
    }
    
    var cellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell,Board>{
        UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
            var config = cell.defaultContentConfiguration()
            config.text = itemIdentifier.name
                //MARK: -- 이거 수리
//            if let imageName = itemIdentifier.pinnedImage.first{
//                Task{@MainActor in
//                    let image = await UIImage(named: imageName)?.byPreparingThumbnail(ofSize: .init(width: 360, height: 360))
//                    config.imageProperties.cornerRadius = 8
//                    config.image = image
//                    config.imageProperties.maximumSize = .init(width: 44, height: 44)
//                    cell.contentConfiguration = config
//                }
//            }
            cell.contentConfiguration = config
        }
    }
    var headerReigstration : UICollectionView.SupplementaryRegistration<UICollectionViewListCell>{
        UICollectionView.SupplementaryRegistration(elementKind: UICollectionView.elementKindSectionHeader) { supplementaryView, elementKind, indexPath in
            var config = supplementaryView.defaultContentConfiguration()
            config.text = "My Boards"
            supplementaryView.contentConfiguration = config
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
extension UIImage{
    func downSample2(size: CGSize, scale: CGFloat = UIScreen.main.scale) -> UIImage {
        let imageSourceOption = [kCGImageSourceShouldCache: false] as CFDictionary
        let data = self.pngData()! as CFData
        let imageSource = CGImageSourceCreateWithData(data, imageSourceOption)!

        let maxPixel = max(size.width, size.height) * scale
        let downSampleOptions = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxPixel
        ] as CFDictionary

        let downSampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downSampleOptions)!

        let newImage = UIImage(cgImage: downSampledImage)
        return newImage
    }
}
