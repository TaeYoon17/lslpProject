//
//  CachedImageManager.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/30.
//

import UIKit
import Photos

actor CachedImageManager {
//    미리보기 썸네일을 쉽게 검색하거나 생성할 수 있는 오브젝트로, 많은 수의 에셋을 일괄적으로 미리 로드하는 데 최적화되어 있습니다.
//    개별 에셋에 대한 이미지가 필요한 경우 requestImage(for:targetSize:콘텐츠모드:옵션:결과처리기:) 메서드를 호출하고 해당 에셋을 준비할 때 사용한 것과 동일한 매개변수를 전달합니다.
    private let imageManager = PHCachingImageManager()
    
//    Options for fitting an image’s aspect ratio to a requested size, used by the requestImage(for:targetSize:contentMode:options:resultHandler:) method.
// 미리 앨범에서 불러올 이미지의 콘텐츠 모드를 설정한다.
    private var imageContentMode = PHImageContentMode.default
    
    enum CachedImageManagerError: LocalizedError {
        case error(Error)
        case cancelled
        case failed
    }
    // 캐시에 담을 이미지들 고유 ID 문자열
    private var cachedAssetIdentifiers = [String : Bool]()
    
    private lazy var requestOptions: PHImageRequestOptions = {
        // Photokit에서 이미지 요청시 추가할 옵션들
        let options = PHImageRequestOptions()
        options.deliveryMode = .opportunistic
        // 이미지 품질을 자동으로 조절한다.
        return options
    }()
    
    init() {
        imageManager.allowsCachingHighQualityImages = false
    }
    
    var cachedImageCount: Int {
        cachedAssetIdentifiers.keys.count
    }
    
    func startCaching(for assets: [PhotoAsset], targetSize: CGSize) {
        let phAssets:[PHAsset] = assets.compactMap { $0.phAsset }
        phAssets.forEach {
            cachedAssetIdentifiers[$0.localIdentifier] = true
        }
        imageManager.startCachingImages(for: phAssets, targetSize: targetSize, contentMode: imageContentMode, options: requestOptions)
    }

    func stopCaching(for assets: [PhotoAsset], targetSize: CGSize) {
        let phAssets = assets.compactMap { $0.phAsset }
        phAssets.forEach {
            cachedAssetIdentifiers.removeValue(forKey: $0.localIdentifier)
        }
        imageManager.stopCachingImages(for: phAssets, targetSize: targetSize, contentMode: imageContentMode, options: requestOptions)
    }
    
    func stopCaching() {
        imageManager.stopCachingImagesForAllAssets()
    }
    
    // 캐시에서 이미지를 가져오기
    @discardableResult
    func requestImage(for asset: PhotoAsset, targetSize: CGSize, completion: @escaping ((image: UIImage?, isLowerQuality: Bool)?) -> Void) -> PHImageRequestID? {
        guard let phAsset = asset.phAsset else {
            completion(nil)
            return nil
        }
        
        let requestID = imageManager.requestImage(for: phAsset, targetSize: targetSize, contentMode: imageContentMode, options: requestOptions) { image, info in
            if let error = info?[PHImageErrorKey] as? Error {
                print("CachedImageManager requestImage error: \(error.localizedDescription)")
                completion(nil)
            } else if let cancelled = (info?[PHImageCancelledKey] as? NSNumber)?.boolValue, cancelled {
                print("CachedImageManager request canceled")
                completion(nil)
            } else if let image = image {
                let isLowerQualityImage = (info?[PHImageResultIsDegradedKey] as? NSNumber)?.boolValue ?? false
                let result = (image: image, isLowerQuality: isLowerQualityImage)
                completion(result)
            } else {
                completion(nil)
            }
        }
        return requestID
    }
    
    func cancelImageRequest(for requestID: PHImageRequestID) {
        imageManager.cancelImageRequest(requestID)
    }
    func requestImage(for asset: PhotoAsset, targetSize: CGSize) async -> (PHImageRequestID?, UIImage?){
        guard let phAsset = asset.phAsset else { return (nil,nil) }
        var myid:PHImageRequestID?
        let hello:UIImage? = await withCheckedContinuation { continuation in
            let id = imageManager.requestImage(for: phAsset, targetSize: targetSize, contentMode: imageContentMode, options: requestOptions) { image, info in
                if let error = info?[PHImageErrorKey] as? Error {
                    print("CachedImageManager requestImage error: \(error.localizedDescription)")
                    continuation.resume(returning: nil)
                } else if let cancelled = (info?[PHImageCancelledKey] as? NSNumber)?.boolValue, cancelled {
                    print("CachedImageManager request canceled")
                    continuation.resume(returning: nil)
                } else if let image = image {
                    continuation.resume(returning: image)
                } else {
                    continuation.resume(returning: nil)
                }
            }
            myid = id
        }
        return (myid,hello)
    }
}

