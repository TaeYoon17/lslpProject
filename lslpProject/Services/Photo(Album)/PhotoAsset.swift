//
//  PhotoAsset.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/30.
//

import Photos
struct PhotoAsset: Identifiable {
    var id: String { identifier }
    var identifier: String = UUID().uuidString
    var index: Int?
    var phAsset: PHAsset?
    typealias MediaType = PHAssetMediaType
    
    var mediaType: MediaType {
        phAsset?.mediaType ?? .unknown
    }
    init(phAsset: PHAsset, index: Int?) {
        self.phAsset = phAsset
        self.index = index
        self.identifier = phAsset.localIdentifier
    }
    
    init(identifier: String) {
        self.identifier = identifier
        let fetchedAssets = PHAsset.fetchAssets(withLocalIdentifiers: [identifier], options: nil)
        self.phAsset = fetchedAssets.firstObject
    }
    
    func setIsFavorite(_ isFavorite: Bool) async {
        guard let phAsset = phAsset else { return }
        Task {
            do {
                try await PHPhotoLibrary.shared().performChanges {
                    let request: PHAssetChangeRequest = PHAssetChangeRequest(for: phAsset)
                    request.isFavorite = isFavorite
                }
            } catch (let error) {
                fatalError("Failed to change isFavorite: \(error.localizedDescription)")
            }
        }
    }
    // 필요 없을거 같은데
    func delete() async {
        guard let phAsset = phAsset else { return }
        do {
            try await PHPhotoLibrary.shared().performChanges {
                PHAssetChangeRequest.deleteAssets([phAsset] as NSArray)
            }
            print("PhotoAsset asset deleted: \(index ?? -1)")
        } catch (let error) {
            fatalError("Failed to delete photo: \(error.localizedDescription)")
        }
    }
}

extension PhotoAsset: Equatable {
    static func ==(lhs: PhotoAsset, rhs: PhotoAsset) -> Bool {
        (lhs.identifier == rhs.identifier) 
//        && (lhs.isFavorite == rhs.isFavorite)
    }
}

extension PhotoAsset: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}

extension PHObject: Identifiable {
    public var id: String { localIdentifier }
}
