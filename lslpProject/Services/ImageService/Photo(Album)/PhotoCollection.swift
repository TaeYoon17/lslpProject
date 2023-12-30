//
//  PhotoCollection.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/30.
//

import Foundation
import Photos
import RxSwift
enum AlbumType:Identifiable,Hashable{
    var id: String{ UUID().uuidString }
    case custom(String)
    case all
}
final class PhotoCollection: NSObject{
    @Published var photoAssets: PhotoAssetCollection = PhotoAssetCollection(PHFetchResult<PHAsset>())
    
    var albumName: String?
    var smartAlbumType: PHAssetCollectionSubtype?
    
    // 앨범 뷰에 보여 줄 때 썸네일들 캐싱 매니저
    let cache = CachedImageManager()
    
    // PHFetchResult를 통해서 얻은 이미지 Collection들
    private var assetCollection: PHAssetCollection?
    private var createAlfumIfNotFound = false
    
    init(smartAlbum smartAlbumType: PHAssetCollectionSubtype) {
        self.smartAlbumType = smartAlbumType
        super.init()
    }
    
    deinit{
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
        print("PhotoCollection은 집으로 갔다")
    }
    
    func load() async throws{
        PHPhotoLibrary.shared().register(self)
        // 스마트 앨범에서 접근하기
        try await getAlbumImages(type: .all)
    }
    func getAlbumImages(type:AlbumType) async throws{
        // 스마트 앨범에서 접근하기
        switch type{
        case .all:
            guard let smartAlbumType else {return}
            if let assetCollection = PhotoCollection.getSmartAlbum(subtype: smartAlbumType){
                print("Loaded smart album of type: \(smartAlbumType.rawValue)")
                self.assetCollection = assetCollection
                await refreshPhotoAssets() // 기존에 존재한 assetCollection Refresh
                return
            }else{
                print("Unable to load smart album of type: : \(smartAlbumType.rawValue)")
                throw PhotoCollectionError.unableToLoadSmartAlbum(smartAlbumType)
            }
        case .custom(let name):
            // 앨범에서 접근하기
//            guard let name = albumName, !name.isEmpty else {
//                print("Unable to load an album without a name.")
//                throw PhotoCollectionError.missingAlbumName
//            }
            if let assetCollection = PhotoCollection.getAlbum(named: name){
                print("Loaded photo album named: \(name)")
                self.assetCollection = assetCollection
                await refreshPhotoAssets()
                return
            }
        }
    }
    private static func getSmartAlbum(subtype: PHAssetCollectionSubtype) -> PHAssetCollection? {
        let fetchOptions = PHFetchOptions()
        let collections = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: subtype, options: fetchOptions)
        return collections.firstObject
    }
    private static func getAlbum(identifier: String) -> PHAssetCollection? {
        let fetchOptions = PHFetchOptions()
        let collections = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [identifier], options: fetchOptions)
        return collections.firstObject
    }
    
    private static func getAlbum(named name: String) -> PHAssetCollection? {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", name)
        let collections = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        return collections.firstObject
    }
}
extension PhotoCollection:PHPhotoLibraryChangeObserver{
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        Task { @MainActor in
            guard let changes:PHFetchResultChangeDetails<PHAsset> = changeInstance.changeDetails(for: self.photoAssets.fetchResult) else { return }
            await self.refreshPhotoAssets(changes.fetchResultAfterChanges)
        }
    }
    
    private func refreshPhotoAssets(_ fetchResult: PHFetchResult<PHAsset>? = nil) async{
        var newFetchResult:PHFetchResult<PHAsset>? = fetchResult
        
        if newFetchResult == nil{
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            // 기존에 있던 assetCollection에 접근한다.
            if let assetCollection = self.assetCollection, let fetchResult = (PHAsset.fetchAssets(in: assetCollection, options: fetchOptions) as AnyObject?) as? PHFetchResult<PHAsset>{
                newFetchResult = fetchResult
            }
        }
        if let newFetchResult = newFetchResult{
            await MainActor.run {
                self.photoAssets = PhotoAssetCollection(newFetchResult)
                print("PhotoCollection photoAssets refreshed: \(self.photoAssets.count)")
            }
        }
    }
}
struct AlbumModel:Identifiable,Hashable {
    var id:String{ name }
    let name:String
    let count:Int
    let albumType: AlbumType
    init(name:String, count:Int, albumType: AlbumType) {
      self.name = name
      self.count = count
        self.albumType = albumType
    }
  }

extension PhotoCollection{
    func listAlbums() -> [AlbumModel]{
        var album:[AlbumModel] = [AlbumModel]()
        let options = PHFetchOptions()
        let userAlbums = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .smartAlbumUserLibrary, options: options)
        userAlbums.enumerateObjects{ (object: AnyObject!, count: Int, stop: UnsafeMutablePointer) in
            if object is PHAssetCollection {
                let obj:PHAssetCollection = object as! PHAssetCollection
                let fetchOptions = PHFetchOptions()
                fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
                fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
                let newAlbum = AlbumModel(name: obj.localizedTitle!, count: obj.estimatedAssetCount,albumType: .custom(obj.localizedTitle!))
                album.append(newAlbum)
            }
        }
        album =  Array(Set(album))
        let allPhotosCount = PHAsset.fetchAssets(with: .image, options: options).count
        let newAlbum = AlbumModel(name: "All Photos", count: allPhotosCount,albumType: .all)
        album.insert(newAlbum, at: 0)
        return album
    }
}

extension PhotoCollection{
// 오류 및 오류 발생 이유를 설명하는 현지화된 메시지를 제공하는 특수 오류입니다.
    enum PhotoCollectionError: LocalizedError {
        case missingAssetCollection
        case missingAlbumName
        case missingLocalIdentifier
        case unableToFindAlbum(String)
        case unableToLoadSmartAlbum(PHAssetCollectionSubtype)
        case addImageError(Error)
        case createAlbumError(Error)
        case removeAllError(Error)
    }
}
