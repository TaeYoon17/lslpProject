//
//  UploadVM.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/21.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit
final class UploadVM{
    let imageSubject: PublishSubject<UIImage> = .init()
    var disposeBag = DisposeBag()
    init(){
        CameraService.shared.viewFinderSubject.subscribe(on: MainScheduler.asyncInstance)
            .bind(to: imageSubject)
            .disposed(by: disposeBag)
    }
    struct Input{
    }
    @MainActor struct Output{
        let imageSubject: PublishSubject<UIImage>
    }
    func outer(_ input: Input)->Output{
        return Output(imageSubject: imageSubject)
    }
}
