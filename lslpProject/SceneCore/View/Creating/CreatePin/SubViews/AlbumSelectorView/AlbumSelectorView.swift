//
//  AlbumSelectorView.swift
//  lslpProject
//
//  Created by 김태윤 on 12/2/23.
//

import SnapKit
import UIKit
import RxSwift
import RxCocoa
final class AlbumSelectorView: UICollectionView{
    weak var vm: CreatingPinVM!
    init(vm: CreatingPinVM){
        super.init(frame: .zero,collectionViewLayout: Self.layout)
        self.vm = vm
        
        self.delegate = self
        self.dataSource = self
        self.register(UICollectionViewListCell.self, forCellWithReuseIdentifier: "cell")
    }
    required init?(coder: NSCoder) {
        fatalError("Don't use storyboard")
    }
}

extension AlbumSelectorView: UICollectionViewDelegate,UICollectionViewDataSource{
    static var layout: UICollectionViewLayout{
        var listConfig = UICollectionLayoutListConfiguration(appearance: .plain)
        listConfig.backgroundColor = .systemRed
        return UICollectionViewCompositionalLayout.list(using: listConfig)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didselectItem!!")
    }
//    override func dequeueReusableCell(withReuseIdentifier identifier: String, for indexPath: IndexPath) -> UICollectionViewCell {
//        super.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
//        guard let cell = self.deq
//    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? UICollectionViewListCell else {return .init()}
        var config = cell.defaultContentConfiguration()
        config.text = "Hello world"
        cell.contentConfiguration = config
        return cell
    }
}
