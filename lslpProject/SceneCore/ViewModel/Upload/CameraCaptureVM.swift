//
//  CameraCaptureVM.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/22.
//

import RxCocoa
import RxSwift
import Foundation
import CoreImage
import Combine
final class CameraCaptureVM{
    weak var uploadVM: UploadVM!
    var disposeBag = DisposeBag()
    struct Input{
        let closeTapped: ControlEvent<Void>
        init(closeTapped: ControlEvent<Void>) {
            self.closeTapped = closeTapped
        }
    }
    @MainActor struct Output{
        let viewFinderImage: PublishSubject<CIImage>
    }
    func outAction(_ input: Input)->Output{
        input.closeTapped.subscribe(with: self){
            owner,_ in
            owner.uploadVM.dismiss.onNext(true)
        }.disposed(by: disposeBag)
        return Output(viewFinderImage: uploadVM.viewFinderImageSubject)
    }
//    func previewStart(){
//        CameraService.shared.previewStart()
//    }
}
