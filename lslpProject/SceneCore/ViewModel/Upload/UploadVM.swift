//
//  UploadVM.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/21.
//

import Foundation
import RxSwift
import RxCocoa
import CoreImage
final class UploadVM{
    //MARK: -- ViewStator
    var dismiss = BehaviorSubject(value: false)
    //MARK: -- Interactor
    let viewFinderImageSubject: PublishSubject<CIImage> = .init()
    var disposeBag = DisposeBag()
    
    init(){
        CameraService.shared.viewFinderSubject
            .bind(to: viewFinderImageSubject)
            .disposed(by: disposeBag)
    }
}

extension UploadVM{
    struct Input{
        
    }
    struct Output{
        var dismiss = BehaviorSubject(value: false)
    }
    func outputActor(_ input: Input)-> Output{
        Output(dismiss: dismiss)
    }
}
