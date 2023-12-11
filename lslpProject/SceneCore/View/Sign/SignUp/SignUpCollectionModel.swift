//
//  SignUpCollectionModel.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/27.
//

import Foundation
import RxDataSources
struct SignUpSection {
    var header: String
    var items: [SignUpItem]
    init(header: String, items: [SignUpItem]) {
        self.header = header
        self.items = items
    }
}
extension SignUpSection: SectionModelType {
    init(original: SignUpSection, items: [SignUpItem]) {
        self = original
        self.items = items
    }
}
struct SignUpItem:Identifiable,Hashable{
    var id: SignUpItemType{
        self.itemType
    }
    static func == (lhs: SignUpItem, rhs: SignUpItem) -> Bool {
        return lhs.itemType == rhs.itemType
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(itemType)
    }
    weak var vm: SignUpVM!
    var itemType: SignUpItemType
}
enum SignUpItemType:CaseIterable{
    case email
    case pw
    case nickname
    case others
}
