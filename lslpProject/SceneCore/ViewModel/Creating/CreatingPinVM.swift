//
//  AlbumVM.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/12/01.
//

import Foundation
import RxSwift
import Combine
import Photos
import OrderedCollections
final class AlbumVM{
    let photoCollection = PhotoCollection(smartAlbum: .smartAlbumUserLibrary)
    let albums:BehaviorSubject<[AlbumItem]> = BehaviorSubject(value: [])
    let selectedAlbums: PublishSubject<[AlbumItem]> = .init()
    
    private(set) var images:AnyModelStore<AlbumItem> = AnyModelStore([])
    private(set) var selectedImage = OrderedDictionary<AlbumItem.ID, AlbumItem>()
    
    private var nowSelected = 0
    let limitedSelectCnt = 10
    var cancellable = Set<AnyCancellable>()
    var disposeBag = DisposeBag()
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
        }else{ //false면 지워줘야하지
            nowSelected -= 1
            selectedImage.removeValue(forKey: item.id)
            item.selectedIdx = -1
            images.insertModel(item: item)
            reItems.append(item)
        }
        // 해봤자 10번 돈다...
        for (idx,(key, val)) in selectedImage.enumerated(){
            var val = val
            val.selectedIdx = idx + 1
            selectedImage[key] = val
            images.insertModel(item: val)
        }
        reItems.append(contentsOf: selectedImage.values.elements)
        selectedAlbums.onNext(reItems)
    }
}
//    private var assetToAlbumStream: ((PHImageRequestID?, UIImage?) -> Void)?
//    lazy var assetsStream: AsyncStream<(PHImageRequestID?, UIImage?)> = {
//        AsyncStream { continuation in
//            assetToAlbumStream = { val,image in
//                continuation.yield((val,image))
//            }
//        }
//    }()
