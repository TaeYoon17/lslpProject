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
import Photos
import PhotosUI

final class CreatingPinVC: BaseVC{
    let vm = CreatingPinVM()
    fileprivate let imageManager = PHCachingImageManager()
    var fetchResult: PHFetchResult<PHAsset>!
    var assetCollection: PHAssetCollection!
    
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    lazy var rxDataSource = RxCollectionViewSectionedReloadDataSource<AlbumSection> {  dataSource, collectionView, indexPath, item in
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BasicCell",for: indexPath) as? MainItemCell else {return .init()}
        cell.albumItem = item
        return cell
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let selected = Observable.zip(collectionView.rx.modelSelected(AlbumItem.self),collectionView.rx.itemSelected).map{($0.0,$0.1.row)}
        let rightTapped = navigationItem.rightBarButtonItem!.rx.tap
        let output = vm.output(.init(mainCellSelected: selected, sendAction: rightTapped))
        output.albumDataSubject
            .subscribe(on: MainScheduler.asyncInstance)
            .bind(to: collectionView.rx.items(dataSource: rxDataSource))
            .disposed(by: disposeBag)
        output.isClose.subscribe(with: self){owner, val in
            if val{ owner.closeAction()}
        }.disposed(by: disposeBag)
    }
    override func configureLayout() {
        view.addSubview(collectionView)
    }
    override func configureNavigation() {
        navigationItem.rightBarButtonItem = .init(title:"Send")
        navigationItem.leftBarButtonItem = .init(barButtonSystemItem: .cancel, target: self, action: #selector(Self.closeTapped))
        
    }
    
    override func configureConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    override func configureView() {
        configureCollectionView()
        view.backgroundColor = .systemBackground
    }
    @objc func closeTapped(){
        self.closeAction()
    }
//    @objc func nextTapped(){
//        print("nextTapped!!")
//    }
}

