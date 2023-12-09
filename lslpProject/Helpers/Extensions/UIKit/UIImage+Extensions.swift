//
//  UIImage+Extensions.swift
//  lslpProject
//
//  Created by 김태윤 on 12/8/23.
//

import UIKit
extension UIImage{
    func jpegData(maxMB: CGFloat) throws -> Data{
        guard let data = self.jpegData(compressionQuality: 1) else { throw Err.FetchError.fetchEmpty }
        let quality: CGFloat = CGFloat(data.count / Int(maxMB * 1000000))
        let image =  self.jpegData(compressionQuality: quality)
        guard let image else { throw Err.FetchError.fetchEmpty}
        return image
    }
}
