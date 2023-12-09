//
//  ButtonAnimations.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/24.
//

import Foundation
import UIKit
extension UIButton{
    var animationSnapshot:ButtonAnimations{ ButtonAnimations(btn: self) }
    func apply(animationSnapshot: ButtonAnimations) throws {
        if animationSnapshot.checkSame(btn: self){
            self.configurationUpdateHandler = animationSnapshot.myHandler
        }else{
            throw SnapshotError.buttonNotSame
        }
    }
}
struct ButtonAnimations{
    private var anims:[()->()] = []
    private var actionByState:[ActionType:[()->()]]
    enum ActionType:CaseIterable{
        case selected
        case highlighed
        case defaults
    }
    private weak var btn : UIButton?
    init(btn: UIButton) {
        self.btn = btn
        self.actionByState =  ActionType.allCases.reduce(into: [:], { partialResult, type in
            partialResult[type] = []
        })
    }
    private init(btn: UIButton?,anims:[()->()],actionByState:[ActionType:[()->()]]){
        self.btn = btn
        self.anims = anims
        self.actionByState = actionByState
    }
    @discardableResult
    func scaleEffect(ratio:CGFloat = 0.9)->Self{
        var anim = self.anims
    
        anim.append{
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.4,initialSpringVelocity: 1,options: .preferredFramesPerSecond60){
                btn?.transform = CGAffineTransform(scaleX: ratio, y: ratio)
            }completion: { _ in
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5,initialSpringVelocity: 0.5,options: .curveEaseIn){
                    btn?.transform = CGAffineTransform(scaleX: 1, y: 1)
                }
            }
        }
        
        return ButtonAnimations(btn: self.btn, anims: anim,actionByState: self.actionByState)
    }
    @discardableResult
    func bgEffect(effectColor:UIColor)->Self{
        var actionByStates = self.actionByState
        let prevColor = self.btn?.configuration?.background.backgroundColor
        let effectAction = {
            self.btn?.configuration?.baseBackgroundColor = effectColor
            self.btn?.configuration?.background.backgroundColor = effectColor
        }
        actionByStates[.selected]?.append(effectAction)
        actionByStates[.highlighed]?.append(effectAction)
        actionByStates[.defaults]?.append {
            self.btn?.configuration?.baseBackgroundColor = prevColor
            self.btn?.configuration?.background.backgroundColor = prevColor
        }
        return ButtonAnimations(btn: self.btn, anims: anims,actionByState: actionByStates)
    }
    func checkSame(btn: UIButton)->Bool{
        return self.btn == btn
    }
}
extension ButtonAnimations{
    var myHandler: UIButton.ConfigurationUpdateHandler{
        return {button in // 1
            switch button.state {
            case .selected,.highlighted,[.selected,.highlighted]:
                anims.forEach { anim in anim() }
                actionByState[.selected]?.forEach({$0() })
// 이렇게 케이스를 전부 나누는게 좋겠지만,
//               일단 위에처럼 selected, highlighted 상태를 모두 동일한 로직을 처리하게 쓰고 있다.
//            case .selected:
//                actionByState[.selected]?.forEach({$0() })
//            case .highlighted:
//                actionByState[.highlighed]?.forEach{$0()}
            default:
                actionByState[.defaults]?.forEach({ $0() })
            }
        }
    }
}
enum SnapshotError: Error{
    case buttonNotSame
}
