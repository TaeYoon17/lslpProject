//
//  PhotoImageBridger.swift
//  lslpProject
//
//  Created by 김태윤 on 12/15/23.
//
import SwiftUI
import PhotosUI

@MainActor final class PhotoImageBridger: ObservableObject {
    @Published  var imageState: ImageState! = .empty
    private var prevImage:UIImage? = nil
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
    @Published var selectedImage: UIImage? = nil
    @Published var croppedImage:UIImage? = nil{
        didSet{
            if let croppedImage{
                imageState = .success(croppedImage)
                self.prevImage = croppedImage
            }else{
                if let prevImage{
                    imageState = .success(prevImage)
                }else{
                    imageState = .empty
                }
            }
        }
    }
    @Published var isCroppedError = false{
        didSet{
            if isCroppedError{
                imageState = .failure(ImageServiceError.PHAssetFetchError)
            }
        }
    }
    private static var cnt = 0
    private var myCnt = 0
    let size = CGSize(width: 360, height: 360)
    init(){
        print("Init!!")
        myCnt = Self.cnt
        Self.cnt += 1
    }
    deinit{ print("\(myCnt) PhotoImageBridger Deinit") }
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
                       self.selectedImage = uiimage
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
