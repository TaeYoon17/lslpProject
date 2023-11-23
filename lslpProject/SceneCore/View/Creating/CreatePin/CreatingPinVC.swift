//
//  CreatingPinVC.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources
final class CreatingPinVC: BaseVC{
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func configureLayout() {
        
    }
    
    
    override func configureNavigation() {
        
    }
    override func configureConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    override func configureView() {
        view.addSubview(collectionView)
    }
}
extension CreatingPinVC{
    var layout: UICollectionViewLayout{
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1 / 4), heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1 / 4)), subitems: [item,item,item,item])
        group.interItemSpacing = .fixed(2)
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
