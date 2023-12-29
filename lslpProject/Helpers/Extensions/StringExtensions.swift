//
//  StringExtensions.swift
//  lslpProject
//
//  Created by 김태윤 on 12/29/23.
//

import Foundation
extension Array where Element == String{
    func hashTagPost()->String{
        self.map{"#\($0)"}.joined(separator: "-")
    }
}
extension String{
    func hashTags()->[String]{
        self.split(separator: "-").map{String($0).replacing("#", with: "")}
    }
}
