//
//  TempAlbumVC.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/29.
//

import UIKit
import Photos

class TempAlbumVC: UIViewController{
    enum Section: Int{
        case allPhotos = 0
        case smartAlbums
        case userCollections
        static let count = 3
    }
    enum CellIdentifier: String{
        case allPhotos,collection
    }
    // Photos에서 이미지 정보를 가져오는 인스턴스
    var allPhotos: PHFetchResult<PHAsset>!
    var smartAlbums: PHFetchResult<PHAssetCollection>!
    var userCollections: PHFetchResult<PHCollection>!
    // NSLocalizedString -> 다국어 대응
    let sectionLocalizedTitles = ["", NSLocalizedString("Smart Albums", comment: ""), NSLocalizedString("Albums", comment: "")]
    
    // 그리드를 그리는 프로퍼티
    
    var fetchResult: PHFetchResult<PHAsset>!
    var assetCollection: PHAssetCollection!
    var availableWidth: CGFloat = 0
    let imageManager = PHCachingImageManager()
    var thumbnailSize: CGSize!
    var previousPreheatRect = CGRect.zero
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        let allPhotosOptions = PHFetchOptions()
        
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        allPhotos = PHAsset.fetchAssets(with: allPhotosOptions)
        smartAlbums = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)
        userCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)
        PHPhotoLibrary.shared().register(self)
        // allPhoto에 맞게 fetchResult에 모두 fetch 해야함...
    }
    deinit{
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
}

extension TempAlbumVC{
    // 앨범 캐시 지우기
    fileprivate func resetCachedAssets() {
        imageManager.stopCachingImagesForAllAssets()
        previousPreheatRect = .zero
    }
}

extension TempAlbumVC: PHPhotoLibraryChangeObserver{
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        
        // 기존 결과와 비교해서 달라진 것들만 가져온다.
        guard let changes:PHFetchResultChangeDetails<PHAsset> = changeInstance.changeDetails(for: fetchResult)
            else { return }
        
        // Change notifications may originate from a background queue.
        // As such, re-dispatch execution to the main queue before acting
        // on the change, so you can update the UI.
        DispatchQueue.main.sync {
            // Hang on to the new fetch result.
            fetchResult = changes.fetchResultAfterChanges
            // If we have incremental changes, animate them in the collection view.
            if changes.hasIncrementalChanges {
                // Handle removals, insertions, and moves in a batch update.
                collectionView.performBatchUpdates({
                    if let removed = changes.removedIndexes, !removed.isEmpty {
                        collectionView.deleteItems(at: removed.map({ IndexPath(item: $0, section: 0) }))
                    }
                    if let inserted = changes.insertedIndexes, !inserted.isEmpty {
                        collectionView.insertItems(at: inserted.map({ IndexPath(item: $0, section: 0) }))
                    }
                    changes.enumerateMoves { fromIndex, toIndex in
                        self.collectionView.moveItem(at: IndexPath(item: fromIndex, section: 0),
                                                to: IndexPath(item: toIndex, section: 0))
                    }
                })
                // We are reloading items after the batch update since `PHFetchResultChangeDetails.changedIndexes` refers to
                // items in the *after* state and not the *before* state as expected by `performBatchUpdates(_:completion:)`.
                if let changed = changes.changedIndexes, !changed.isEmpty {
                    collectionView.reloadItems(at: changed.map({ IndexPath(item: $0, section: 0) }))
                }
            } else {
                // Reload the collection view if incremental changes are not available.
                collectionView.reloadData()
            }
            resetCachedAssets()
        }
    }
    
    
}
