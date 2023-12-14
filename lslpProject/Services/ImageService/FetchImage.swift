//
//  FetchImage.swift
//  lslpProject
//
//  Created by 김태윤 on 12/15/23.
//

import Foundation
import UIKit
import Photos
import PhotosUI
extension UIImage{
    static func fetchBy(data:Data,size:CGSize? = nil) -> UIImage{
        return UIImage(cgImage: ImageSampler().get(data: data,size: size))
    }
    static func fetchBy(url: URL,size:CGSize? = nil) async throws -> UIImage{
        let (data,response) = try await URLSession.shared.data(from: url)
        let img = ImageSampler().get(data: data,size: size)
        return fetchBy(data: data, size: size)
    }
    static func fetchBy(fileName:String,size:CGSize? = nil)async throws -> UIImage{
        guard let documentDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw ImageServiceError.EmptyURL
        }
        let fileURL:URL = documentDir.appendingPathComponent("\(fileName).jpg")
        if FileManager.default.fileExists(atPath: fileURL.path){
            let url = fileURL as NSURL
            return UIImage(cgImage:ImageSampler().get(url: url,size:size))
        }else{
            throw ImageServiceError.EmptyURL
        }
    }
    static func fetchBy(phResult: PHPickerResult,size: CGSize? = nil) async throws -> UIImage{
        let item = phResult.itemProvider
        guard let image = try await item.loadimage() else {
            throw ImageServiceError.PHAssetFetchError
        }
        return if let size{
            UIImage(cgImage: ImageSampler().get(uiImage: image, size: size))
        }else{image }
    }
}
//MARK: -- 아이템 Sampling을 가져오기
extension NSItemProvider{
    func loadimage() async throws ->UIImage?{
        let type: NSItemProviderReading.Type = UIImage.self
        return try await withCheckedThrowingContinuation { continuation in
            loadObject(ofClass: type) { (image, error) in
                if let error{
                    continuation.resume(throwing: error)
                }
                continuation.resume(returning: image as? UIImage)
            }
        }
    }
}
fileprivate struct ImageSampler{
    //MARK: -- 코어 로직
    private let imageSourceOption = [kCGImageSourceShouldCache: false] as CFDictionary
    private func downSample(source: CGImageSource,size:CGSize? = nil)->CGImage{
        let scale = UIScreen.main.scale
        let maxPixel = if let size{ max(size.width, size.height) * scale
        }else{ UIScreen.main.bounds.height * scale }
        let downSampleOptions = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxPixel
        ] as CFDictionary
        return CGImageSourceCreateThumbnailAtIndex(source, 0, downSampleOptions)!
    }
    private func getSamplingSource(url: CFURL)->CGImageSource{
        CGImageSourceCreateWithURL(url, imageSourceOption)!
    }
    private func getSamplingSource(data: CFData)->CGImageSource{
        CGImageSourceCreateWithData(data, imageSourceOption)!
    }
}
extension ImageSampler{
    func get(data:Data,size:CGSize? = nil) ->CGImage{
        let imageSource = getSamplingSource(data: data as CFData)
        return downSample(source: imageSource, size: size)
    }
    func get(url:NSURL,size: CGSize? = nil, scale: CGFloat = UIScreen.main.scale) -> CGImage {
        let imageSource = getSamplingSource(url: url as CFURL)
        return downSample(source: imageSource, size: size)
    }
    func get(uiImage:UIImage,size:CGSize? = nil) -> CGImage{
        let data = uiImage.jpegData(compressionQuality: 1)!
        return self.get(data: data,size: size)
    }
}
