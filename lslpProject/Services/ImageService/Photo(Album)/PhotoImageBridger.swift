//
//  PhotoImageBridger.swift
//  lslpProject
//
//  Created by 김태윤 on 12/15/23.
//

import SwiftUI
import PhotosUI
@MainActor final class PhotoImageBridger: ObservableObject {
    @Published private(set) var imageState: ImageState = .empty
    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            if let imageSelection {
                let progress = loadTransferable(from: imageSelection)
                imageState = .loading(progress)
            } else {
                imageState = .empty
            }
        }
    }
    let size:CGSize?
    // MARK: - Private Methods
    init(size: CGSize? = nil){
        self.size = size
    }
    private func loadTransferable(from imageSelection: PhotosPickerItem) -> Progress {
        return imageSelection.loadTransferable(type: ImageData.self) {[weak self] result in
            guard let self else {return}
            Task {@MainActor [weak self] in
                guard let self else {return}
                guard imageSelection == self.imageSelection else {
                    print("Failed to get the selected item.")
                    return
                }
                switch result {
                case .success(let profileImage?):
                    let uiimage = UIImage.fetchBy(data: profileImage.image,size: self.size)
                    self.imageState = .success(uiimage)
                case .success(nil):
                    self.imageState = .empty
                case .failure(let error):
                    self.imageState = .failure(error)
                }
            }
        }
    }
}
extension PhotoImageBridger{
    enum ImageState {
        case empty
        case loading(Progress)
        case success(UIImage)
        case failure(Error)
    }
    struct ImageData: Transferable {
        let image: Data
        static var transferRepresentation: some TransferRepresentation {
            DataRepresentation(importedContentType: .image) { data in
                return ImageData(image: data)
            }
        }
    }
}
