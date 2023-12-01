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
    var id:String{ photoAsset.identifier }
    let photoAsset: PhotoAsset
    var selectedIdx: Int
    init(photoAsset: PhotoAsset, selectedIdx: Int) {
        self.photoAsset = photoAsset
        self.selectedIdx = selectedIdx
    }
    init(photoAsset:PhotoAsset) {
        self.init(photoAsset: photoAsset, selectedIdx: -1)
    }
}
