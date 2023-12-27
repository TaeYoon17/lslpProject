//
//  CreatingPinInfoVM.swift
//  lslpProject
//
//  Created by 김태윤 on 12/1/23.
//

import Foundation
import RxSwift
import RxCocoa
import Photos
enum PinInfoDetail{
    case board
    case tag
}
final class CreatingPinInfoVM{
    weak var imageCache: CachedImageManager!
    var images: [PhotoAsset]
    var pinPost = PinPost()
    let title = BehaviorSubject(value: "")
    let description = BehaviorSubject(value: "")
    let link = BehaviorSubject(value: "")
    let board = BehaviorSubject(value: "")
    var disposeBag = DisposeBag()
    let detailSetting:PublishSubject<PinInfoDetail> = PublishSubject()
    init(_ superVM: CreatingPinVM){
        imageCache = superVM.selectedImageCache
        images = superVM.selectedImage.values.map(\.photoAsset)
        imageToData()
        binding()
    }
    func binding(){
        Observable.combineLatest(title, description,link,board).bind(with: self) { owner, args in
            let (title,description,link,board) = args
            owner.pinPost.title = title
            owner.pinPost.content = description
            owner.pinPost.link = link
            owner.pinPost.board = board
        }.disposed(by: disposeBag)
    }
    func upload(){
        print("upload!!")
        do{
            print(pinPost)
        }catch{
            print(error)
        }
    }
}
extension CreatingPinInfoVM{
    fileprivate func imageToData(){
        Task{
            let imgs = try await self.imageCache.requestImages(assets:images)
            let dataCounter = TaskCounter()
            let datas = try await dataCounter.run(imgs) {
                return try $0.jpegData(maxMB: 10)
            }
            self.pinPost.imageDatas = datas
        }
    }
}
