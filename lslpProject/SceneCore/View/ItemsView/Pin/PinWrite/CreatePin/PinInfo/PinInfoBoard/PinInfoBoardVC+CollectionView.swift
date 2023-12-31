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
extension PinInfoBoardVC:UICollectionViewDelegate{
    func configureCollectionView(){
        self.collectionView.delegate = self
        collectionView.backgroundColor = .systemRed
        let cellRegi = cellRegistration
        let headerRegi = headerReigstration
        dataSource = .init(vm:vm,collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
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
}
extension PinInfoBoardVC{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        vm.selectedItemID.onNext(dataSource.itemIdentifier(for: indexPath)?.id)
        vm.selectedItemName.onNext(dataSource.itemIdentifier(for: indexPath)?.name ?? "")
        dataSource.selectedItem()
        self.navigationController?.popViewController(animated: true)
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
