//
//  CIImage+Extensions.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/21.
//

import Foundation
import CoreImage
import UIKit
extension CIImage{
    var uiImage:UIImage{
        UIImage(ciImage: self)
    }
}
