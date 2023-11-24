//
//  SignInVC.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
final class SignInVC: BaseVC{
    let vm = SignInVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapAction = tempBtn.rx.tap
        let output = vm.output(.init(signInTap: tapAction))
        output.singInResponse
            .debounce(.microseconds(1), scheduler: MainScheduler.instance)
//            .subscribe(on: MainScheduler.instance)
            .bind(with: self) { owner, val in
            if let val{
                let alert = UIAlertController(title: "에러존재", message: nil, preferredStyle: .alert)
                let action = UIAlertAction(title: "취소", style: .cancel)
                alert.addAction(action)
//                Task{@MainActor in
                    owner.present(alert, animated: true)
//                }
                
            }else{
                let alert = UIAlertController(title: "에러없음", message: nil, preferredStyle: .alert)
                let action = UIAlertAction(title: "오케", style: .cancel)
                alert.addAction(action)
//                Task{@MainActor in
                    owner.present(alert, animated: true)
//                }
            }
        }.disposed(by: disposeBag)
//        tapAction.subscribe(with: self){owner, _ in
//            owner.closeAction()
//            changeMainView()
//        }.disposed(by: disposeBag)
    }
    let tempBtn = UIButton(configuration: .filled())
    override func configureLayout() {
        view.addSubview(tempBtn)
    }
    override func configureConstraints() {
        print("actioned!!")
        tempBtn.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    override func configureNavigation() {
        
    }
    override func configureView() {
        view.backgroundColor = .systemBackground
        tempBtn.setTitle("Hello World!!", for: .normal)
        tempBtn.setTitleColor(.systemBackground, for: .normal)
        tempBtn.tintColor = .systemBlue
    }
    
}
