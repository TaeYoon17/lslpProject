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
    final class DataSource: UICollectionViewDiffableDataSource<String,Item>{
        typealias Item = PinInfoBoardVC.Item
        weak var vm: PinInfoBoardVM!
        var disposeBag = DisposeBag()
        init(vm:PinInfoBoardVM,collectionView: UICollectionView, cellProvider: @escaping UICollectionViewDiffableDataSource<String, Item>.CellProvider){
            super.init(collectionView: collectionView, cellProvider: cellProvider)
            self.vm = vm
            vm.boardsSubject
                .map {boards in
                    boards.map{
                        let check = (try? vm.selectedItemID.value()) == $0.id
                        return Item(id: $0.id, name: $0.name, hashTags: $0.hashTags.reduce("", {$0 + "#\($1) "}), imageData: $0.data, check: check)
                }}.subscribe(on: MainScheduler.instance)
                .bind(with: self) { owner, board in
                owner.new(boards: board)
            }.disposed(by: disposeBag)
        }
        func selectedItem(){
            var snapshot = snapshot()
            var items = snapshot.itemIdentifiers(inSection: "wow").map{
                var item = $0
                item.check = (try? vm.selectedItemID.value()) == $0.id
                return item
            }
            new(boards: items,animating: false)
        }
        func new(boards:[Item],animating:Bool = true){
            var snapshot = NSDiffableDataSourceSnapshot<String,Item>()
            snapshot.appendSections(["wow"])
            snapshot.appendItems(boards)
            apply(snapshot,animatingDifferences: animating)
        }
    }
    struct Item:Identifiable,Hashable{
        var id:String
        var name:String
        var hashTags:String
        var imageData:Data?
        var check: Bool
    }
}
