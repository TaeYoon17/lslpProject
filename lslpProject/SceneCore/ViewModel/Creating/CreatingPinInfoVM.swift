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
    var images: [PhotoAsset] = []
    var pinPost = PinPost()
    let title = BehaviorSubject(value: "")
    let description = BehaviorSubject(value: "")
    let link = BehaviorSubject(value: "")
    let board = BehaviorSubject(value: "")
    let hashTags :BehaviorSubject<[String]> = .init(value: [])
    let boardID :BehaviorSubject<String?> = .init(value: nil)
    let isCreateAble = BehaviorSubject(value: false)
    var disposeBag = DisposeBag()
    
    let detailSetting:PublishSubject<PinInfoDetail> = PublishSubject()
    init(_ superVM: CreatingPinVM){
        self.imageCache = superVM.selectedImageCache
        Task{@MainActor in
            self.images = superVM.selectedImage.values.map(\.photoAsset)
            try await imageToData()
        }
        binding()
    }
    func binding(){
        Observable.combineLatest(title, description,link,boardID,hashTags).bind(with: self) { owner, args in
            let (title,description,link,boardID,hashTags) = args
            owner.pinPost.title = title
            owner.pinPost.content = description
            owner.pinPost.link = link
            owner.pinPost.board = boardID ?? ""
            owner.pinPost.hashTags = hashTags.hashTagPost()
        }.disposed(by: disposeBag)
        Observable.combineLatest(title,board,hashTags).map{
            !$0.isEmpty && !$1.isEmpty && !$2.isEmpty
        }.bind(to: isCreateAble).disposed(by: disposeBag)
    }
    func upload() async {
//        print("upload!!")
        print(pinPost)
        do{
            try await NetworkService.shared.post(pinPost: pinPost)
        }catch{
            print(error)
        }
    }
}
extension CreatingPinInfoVM{
    fileprivate func imageToData() async throws{
        let imgs = try await self.imageCache.requestImages(assets:images)
        let dataCounter = TaskCounter()
        let cnt = max(2,CGFloat(5 / imgs.count))
        print("cnt",cnt)
        let datas = try await dataCounter.run(imgs) {
            return try $0.jpegData(maxMB: cnt)
        }
        self.pinPost.imageDatas = datas
    }
}
