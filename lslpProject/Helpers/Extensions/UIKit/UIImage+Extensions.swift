//
//  UIImage+Extensions.swift
//  lslpProject
//
//  Created by 김태윤 on 12/8/23.
//

import UIKit
extension UIImage{
    func jpegData(maxMB: CGFloat = 3) throws -> Data{
        guard let data = self.jpegData(compressionQuality: 1) else { throw Err.FetchError.fetchEmpty }
        let quality: CGFloat = (1000000.0 * maxMB) / CGFloat(data.count) 
        let val = max(0,min(0.9,quality))
        print("--------val--------")
        print(val)
        let image =  self.jpegData(compressionQuality: val)
        guard let image else {
            throw Err.FetchError.fetchEmpty
        }
        guard image.count < Int(maxMB) * 1000000 else {
            fatalError("최대치를 넘어")
        }
        return image
    }
    static func fetchBy(data: Data,size: CGSize) -> UIImage{
        let scale = UIScreen.main.scale
        let imageSourceOption = [kCGImageSourceShouldCache: false] as CFDictionary
        let imageSource = CGImageSourceCreateWithData(data as CFData, imageSourceOption)!
        let maxPixel = max(size.width, size.height) * scale
        let downSampleOptions = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxPixel
        ] as CFDictionary
        
        let downSampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downSampleOptions)!
        
        return UIImage(cgImage: downSampledImage)
    }
}
