//
//  DateExtension.swift
//  lslpProject
//
//  Created by 김태윤 on 12/16/23.
//

import Foundation
extension Date{
    var yyyyMMdd:String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        return dateFormatter.string(from: self)
    }
    init(yyyyMMdd:String){
        self.init()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        self = dateFormatter.date(from: yyyyMMdd)!
    }
}
