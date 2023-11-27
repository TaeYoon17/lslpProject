//
//  LogInBtn.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/27.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class LogInBtn: OnboardingBtn{
    let bgColor: UIColor
    let textColor: UIColor
    let holderColor: UIColor
    let holderBgColor: UIColor
    var isAvailableLogIn = BehaviorSubject(value: false)
    var disposeBag = DisposeBag()
    init(text: String, textColor: UIColor,bgColor: UIColor, holderColor: UIColor,holderBgColor: UIColor){
        self.textColor = textColor
        self.bgColor = bgColor
        self.holderColor = holderColor
        self.holderBgColor = holderBgColor
        super.init(text: text, textColor: textColor, bgColor: bgColor)
        isAvailableLogIn.bind(to: self.rx.isUserInteractionEnabled).disposed(by: disposeBag)
        isAvailableLogIn.bind(with: self) { owner, isAvailable in
            owner.configuration?.background.backgroundColor = isAvailable ? bgColor : holderBgColor
            owner.configuration?.baseForegroundColor = isAvailable ? textColor : holderColor
        }.disposed(by: disposeBag)
        var animSnap = self.animationSnapshot
        animSnap.scaleEffect(ratio: 0.95)
        do{
            try self.apply(animationSnapshot: animSnap)
        }catch{
            print(error)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("Don't use storyboard")
    }
}
