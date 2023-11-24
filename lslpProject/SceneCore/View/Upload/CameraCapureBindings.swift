//
//  CameraCapureBindings.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/22.
//

import SnapKit
import UIKit
import RxSwift
import RxCocoa
extension CameraCaptureView{
    func bindingViewFinderLoading(_ viewFinderImage:PublishSubject<CIImage>){
        let takeObservable = viewFinderImage.take(1)
        let mainTakeObservable = if CameraService.shared.isPreviewFirst{
            takeObservable.delay(.milliseconds(480), scheduler: MainScheduler.asyncInstance)
        }else{
            takeObservable.subscribe(on: MainScheduler.asyncInstance)
        }
        mainTakeObservable.subscribe(with: self){ owner, _ in
            owner.maskLayer?.removeFromSuperlayer()
            Task{
                owner.activityIndicator.stopAnimating()
                owner.activityIndicator.isHidden = true
            }
        }.disposed(by: disposeBag)
    }
}
