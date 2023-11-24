//
//  CreateItem.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/23.
//

import Foundation
import RxDataSources
struct AlbumSection {
    var header: String
    var items: [AlbumItem]
    init(header: String, items: [AlbumItem]) {
        self.header = header
        self.items = items
    }
}
extension AlbumSection: SectionModelType {
    init(original: AlbumSection, items: [AlbumItem]) {
        self = original
        self.items = items
    }
}
struct AlbumItem:Identifiable,Hashable{
    var id:String {albumID}
    var albumID:String
    var selectedIdx: Int
    init(albumID: String, selectedIdx: Int) {
        self.albumID = albumID
        self.selectedIdx = selectedIdx
    }
    init(albumID:String) {
        self.init(albumID: albumID, selectedIdx: -1)
    }
}
