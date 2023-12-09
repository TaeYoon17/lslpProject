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
    let updatedAlbums: BehaviorSubject<[AlbumItem]> = .init(value: [])
    let selectedAlbums: BehaviorSubject<[AlbumItem]> = .init(value: [])
    
    private(set) var images: AnyModelStore<AlbumItem> = AnyModelStore([])
    private(set) var selectedImage = OrderedDictionary<AlbumItem.ID, AlbumItem>()
    
    private var nowSelected = 0
    let limitedSelectCnt = 5 
    
    let openAlbumSelector = BehaviorSubject(value: false)
    var cancellable = Set<AnyCancellable>()
    var disposeBag = DisposeBag()
    deinit{
        print("CreatingPinVM은 집에 간다...")
    }
    init(){
        loadPhotos()
        photoCollection.$photoAssets.sink { [weak self] collection in
            guard let self else {return}
            let albumItems = collection.map{AlbumItem(photoAsset: $0)}
            images = .init(albumItems)
            selectedImage = .init()
            albums.onNext(albumItems)
            selectedAlbums.onNext(selectedImage.values.elements)
        }.store(in: &cancellable)
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
        if item.selectedIdx < 0 && nowSelected >= limitedSelectCnt{ return }
        if item.selectedIdx < 0{
            nowSelected += 1
            item.selectedIdx = nowSelected
            selectedImage[item.id] = item
            let photoAsset = item.photoAsset
            Task{
                await selectedImageCache.startCaching(for: [photoAsset], targetSize: PHImageManagerMaximumSize)
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
    
//    func getSelectedImages()async{
//        Task{
//            var images:[UIImage] = []
//            for album in selectedImage.values{
//                await selectedManager.requestImage(for: album.photoAsset, targetSize: PHImageManagerMaximumSize) { arg in
//                    if let arg,let image = arg.image{
//                        images.append(image)
//                    }
//                }
//            }
//        }
//    }
}
