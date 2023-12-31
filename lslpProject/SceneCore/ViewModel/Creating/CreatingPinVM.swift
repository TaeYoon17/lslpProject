//
//  AlbumVM.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/12/01.
//

import Foundation
import RxSwift
import Combine
import OrderedCollections
import Photos
import UIKit
final class CreatingPinVM{
    let photoCollection = PhotoCollection(smartAlbum: .smartAlbumUserLibrary)
    let selectedImageCache = CachedImageManager(isCachingHighQuality: true)
    let albums:BehaviorSubject<[AlbumItem]> = BehaviorSubject(value: [])
    // 이미지 리스트에서 선택한 것들 reload
    let updatedAlbums: BehaviorSubject<[AlbumItem]> = .init(value: [])
    let selectedAlbums: BehaviorSubject<[AlbumItem]> = .init(value: [])
    
    private(set) var images: AnyModelStore<AlbumItem> = AnyModelStore([])
    private(set) var selectedImage = OrderedDictionary<AlbumItem.ID, AlbumItem>()
    
    private var nowSelected = 0
    let limitedSelectCnt = 5
    
    let openAlbumSelector = BehaviorSubject(value: false)
    let openAlbumName = BehaviorSubject(value: "All Photos")
    var cancellable = Set<AnyCancellable>()
    var disposeBag = DisposeBag()
    
    // 앨범 리스트 설정하기
    let albumList: BehaviorSubject<[AlbumModel]> = .init(value: [])
    let selectedAlbumModel: PublishSubject<AlbumModel> = .init()
    deinit{
        print("CreatingPinVM은 집에 간다...")
    }
    init(){
        loadPhotos()
        photoCollection.$photoAssets.sink { [weak self] collection in
            guard let self else {return}
            let albumItems = collection.map{AlbumItem(photoAsset: $0)}
            images = .init(albumItems)
            albums.onNext(albumItems)
            let albumSets = Set(albumItems)
                for key in self.selectedImage.keys{
                    if let item = albumSets.first(where: {$0.id == key})?.photoAsset{
                        self.selectedImage[key]?.photoAsset = item
                    }
                }
                for (idx,(key, val)) in self.selectedImage.enumerated(){
                    var val = val
                    val.selectedIdx = idx + 1
                    self.selectedImage[key] = val
                    self.images.insertModel(item: val)
                }
                let values = self.selectedImage.values.elements
                self.selectedAlbums.onNext(values)
                self.updatedAlbums.onNext(values)
        }.store(in: &cancellable)
        albumList.onNext(self.photoCollection.listAlbums())
        self.selectedAlbumModel.bind(with: self) { owner, model in
            owner.openAlbumName.onNext(model.name)
            owner.openAlbumSelector.onNext(false)
            owner.selectedImage = .init()
            owner.nowSelected = 0
            owner.selectedAlbums.onNext([])
            owner.updatedAlbums.onNext([])
            Task{
                try await owner.photoCollection.getAlbumImages(type: model.albumType)
            }
        }.disposed(by: disposeBag)
    }
    
    func loadPhotos(){
        Task{
            do{
                try await photoCollection.load()
            }catch{
                print(error)
            }
        }
    }
    func toggleCheckItem(_ item:AlbumItem){
        var item = item
        var reItems:[AlbumItem] = []
        if item.selectedIdx < 0{
            if nowSelected >= limitedSelectCnt{ return}
            nowSelected += 1
            item.selectedIdx = nowSelected
            selectedImage[item.id] = item
            let photoAsset = item.photoAsset
            Task{
                await photoCollection.cache.startCaching(for:[photoAsset],targetSize:PHImageManagerMaximumSize)
            }
        }else{ //false면 지워줘야하지
            nowSelected -= 1
            selectedImage.removeValue(forKey: item.id)
            item.selectedIdx = -1
            images.insertModel(item: item)
            reItems.append(item)
        }
        // 해봤자 5번 돈다...
        for (idx,(key, val)) in selectedImage.enumerated(){
            var val = val
            val.selectedIdx = idx + 1
            selectedImage[key] = val
            images.insertModel(item: val)
        }
        reItems.append(contentsOf: selectedImage.values.elements)
        updatedAlbums.onNext(reItems)
        selectedAlbums.onNext(selectedImage.values.elements)
    }
}
