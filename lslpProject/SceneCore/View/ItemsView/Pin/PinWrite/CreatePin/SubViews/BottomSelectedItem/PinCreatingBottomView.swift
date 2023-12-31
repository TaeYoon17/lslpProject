//
//  PinCreatingBottomView.swift
//  lslpProject
//
//  Created by 김태윤 on 12/1/23.
//

import UIKit
import SnapKit
final class PinCreatingBottomView: UICollectionView{
    weak var vm: CreatingPinVM!
    var diffableDataSource: BottomDataSource!
    init(vm: CreatingPinVM){
        super.init(frame: .zero, collectionViewLayout: Self.layout)
        self.vm = vm
        let cellRigi = cellReigistration
        self.showsHorizontalScrollIndicator = false
        diffableDataSource = .init(vm: vm, collectionView: self, cellProvider: { collectionView, indexPath, itemIdentifier in
            collectionView.dequeueConfiguredReusableCell(using: cellRigi, for: indexPath, item: itemIdentifier)
        })
        self.delegate = self
    }
    required init?(coder: NSCoder) {
        fatalError("Don't use storyboard")
    }
}
extension PinCreatingBottomView:UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let itemIdentifier = diffableDataSource.itemIdentifier(for: indexPath),
              let item = vm.images.fetchByID(itemIdentifier) else {return}
        vm.toggleCheckItem(item)
    }
    static fileprivate var layout: UICollectionViewLayout{
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalHeight(1), heightDimension: .fractionalHeight(1)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = .init(top: 4, leading: 16, bottom: 4, trailing: 16)
        let layout = UICollectionViewCompositionalLayout(section: section)
        let  layoutConfig = UICollectionViewCompositionalLayoutConfiguration()
        layoutConfig.scrollDirection = .horizontal
        
        layout.configuration = layoutConfig
        return layout
    }
}
