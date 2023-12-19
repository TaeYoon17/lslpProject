//
//  GridType.swift
//  lslpProject
//
//  Created by 김태윤 on 12/20/23.
//

import SwiftUI
enum GridType:CaseIterable{
    case wide
    case def
    case compact
    
    var name:String{
        switch self{
        case .compact: "Compact"
        case .def: "Default"
        case .wide: "Wide"
        }
    }
    var gridColumns:Int{
        return switch self{
        case .compact: 3
        case .def: 2
        case .wide: 1
        }
        
    }
    var gridIcon:String{
        switch self{
        case .compact:"square.grid.3x3.fill"
        case .def: "square.grid.2x2.fill"
        case .wide:  "square.fill"
        }
    }
}
