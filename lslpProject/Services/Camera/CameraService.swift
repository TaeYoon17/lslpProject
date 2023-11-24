//
//  CameraService.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/21.
//

import UIKit
import SnapKit
import RxSwift
import Combine
import CoreImage
final class CameraService{
    private let camera = Camera()
    var viewFinderSubject:PublishSubject<CIImage> = .init()
    var disposeBag = DisposeBag()
    var isPreviewFirst = true
    static let shared = CameraService()
    private init(){
        cameraBinding()
    }
    
    func cameraBinding(){
        Task{[weak self]  in
            guard let self else {return}
            let compactPreviewStream = camera.previewStream.compactMap({$0})
            for await iamge in compactPreviewStream{
                self.viewFinderSubject.onNext(iamge)
            }
        }
    }
    func previewStart() {
        Task.detached(priority: .high){[weak self] in
            guard let self else {return}
            await self.camera.start()
        }
    }
    func previewStop(){
        camera.stop()
        isPreviewFirst = false
    }
}
