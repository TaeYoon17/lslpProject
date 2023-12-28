//
//  PinInfoBoardVM.swift
//  lslpProject
//
//  Created by 김태윤 on 12/28/23.
//

import Foundation
import RxSwift
import RxCocoa

final class PinInfoBoardVM{
    let boardsSubject:BehaviorSubject<[Board]>
    let selectedItemID:BehaviorSubject<String?>
    let selectedItemName: BehaviorSubject<String>
    init(itemID:String?,itemName:String){
        self.boardsSubject = .init(value: App.Manager.shared.boards)
        self.selectedItemID = .init(value: itemID)
        self.selectedItemName = .init(value: itemName)
    }
    deinit{
        
        print("PinInfoBoardVM Deinit")
    }
}
