//
//  OptionTypable.swift
//  lslpProject
//
//  Created by 김태윤 on 12/26/23.
//

import Foundation
protocol OptionTypable:CaseIterable{
    var name:String { get }
    static var header:String { get }
}
