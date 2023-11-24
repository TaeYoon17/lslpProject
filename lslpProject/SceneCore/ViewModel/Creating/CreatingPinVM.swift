//
//  CreatingPinVM.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/23.
//

import Foundation
import RxSwift
import RxCocoa
import OrderedCollections
import UIKit
final class CreatingPinVM{
    let albumDataSubject: BehaviorSubject<[AlbumItem]>
    private(set) var selectedImage = OrderedDictionary<AlbumItem.ID, AlbumItem>()
    private var nowSelected = 0
    let limitedSelectCnt = 10
    var disposeBag = DisposeBag()
    init(){
        let dummyItems:[AlbumItem] = [
                            .init(albumID: "ARKit"),
                            .init(albumID: "AsyncSwift"),
                            .init(albumID: "C++"),
                            .init(albumID: "macOS"),
                            .init(albumID: "Metal")
                        ]
        self.albumDataSubject = .init(value:dummyItems)
    }
    struct Input{
        let mainCellSelected: Observable<(AlbumItem, Int)>
        let sendAction: ControlEvent<()>
    }
    struct Output{
        let albumDataSubject: Observable<[AlbumSection]>
        let isClose: BehaviorSubject<Bool>
    }
    func output(_ input: Input)->Output{
        do{
            var nowAlbumData = try albumDataSubject.value()
            input.mainCellSelected.bind(with: self) { owner, args in
                let (albumItem,_ ) = args
                owner.toggleCheckItem(albumItem)
                nowAlbumData = nowAlbumData.map({
                    var item = $0
                    item.selectedIdx = (owner.selectedImage.index(forKey: item.id) ?? -2) + 1
                    return item
                })
                owner.albumDataSubject.onNext(nowAlbumData)
            }.disposed(by: disposeBag)
        }catch{
            print(error)
        }
        let rxDataSourceBinder = self.albumDataSubject.map { items in
            [AlbumSection(header: "header", items: items)]
        }
        let closeSubject = BehaviorSubject(value: false)
        
        input.sendAction.subscribe(with: self){owner, _ in
            let imageDatas = owner.selectedImage.elements.compactMap{ UIImage(named: $0.value.albumID)?.jpegData(compressionQuality: 0.3)}
            NetworkService.shared.uploadPost(PostUpload(title: "고래1", content: "고래밥", imageDatas: imageDatas))
        }.disposed(by: disposeBag)
        input.sendAction.map{true}.bind(to: closeSubject).disposed(by: disposeBag)
        return Output(albumDataSubject:rxDataSourceBinder,isClose: closeSubject)
    }
}
extension CreatingPinVM{
    func toggleCheckItem(_ item:AlbumItem){
        var item = item
        if item.selectedIdx < 0 && nowSelected >= limitedSelectCnt{ return }
        if item.selectedIdx < 0{
            nowSelected += 1
            item.selectedIdx = nowSelected
            selectedImage[item.id] = item
        }else{ //false면 지워줘야하지
            nowSelected -= 1
            selectedImage.removeValue(forKey: item.id)
        }
    }
}
