//
//  CreatingVC.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/23.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
final class CreatingVC: BaseVC{
    weak var vm:CreatingVM!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        zip(App.CreateType.allCases, [pinBtn,collageBtn,boardBtn])
            .forEach { type, btn in
                btn.rx.tap.map{_ in type}
                    .subscribe(vm.startCreateType)
                    .disposed(by: disposeBag)
                btn.rx.tap.subscribe(with: self){owner, _ in
                    owner.closeTapped()
                }.disposed(by: disposeBag)
            }
    }
    let pinBtn = ItemButton(systemName: "wand.and.rays")
    let collageBtn = ItemButton(systemName: "scissors")
    let boardBtn = ItemButton(systemName: "clipboard")
    lazy var stView = {
        let subViews = [pinBtn,collageBtn,boardBtn]
        let st = UIStackView(arrangedSubviews: [UIView(),subViews[0],subViews[1],subViews[2],UIView()])
        st.axis = .horizontal
        st.distribution = .equalSpacing
        st.alignment = .center
        subViews.forEach { v in
            v.snp.makeConstraints { make in
                make.height.equalTo(88)
                make.width.equalTo(v.snp.height)
            }
        }
        st.spacing = 16
        return st
    }()
    
    override func configureView() {
    }
    override func configureLayout() {
        view.addSubview(stView)
    }
    override func configureConstraints() {
        stView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(240)
            make.horizontalEdges.equalToSuperview()
        }
    }
    override func configureNavigation() {
        navigationItem.title = "Start creating now"
        navigationItem.leftBarButtonItem = .init(image: UIImage(systemName: "xmark"), style: .done, target: self, action: #selector(Self.closeTapped))
        navigationItem.leftBarButtonItem?.tintColor = .text
    }
    @objc func closeTapped(){
        self.closeAction()
    }
}
final class ItemButton: UIButton{
    let imageConfig = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 14, weight: .heavy))
    let defaultName:String
    let tappedName:String
    init(systemName: String,tappedName: String? = nil){
        self.defaultName = systemName
        self.tappedName = tappedName ?? systemName
        super.init(frame: .zero)
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: systemName,withConfiguration: imageConfig)
        config.baseBackgroundColor = .lightGray
        config.baseForegroundColor = .text
        config.background.cornerRadius = 16
        config.background.visualEffect = UIBlurEffect(style: .light)
        config.preferredSymbolConfigurationForImage = imageConfig
        let handler: UIButton.ConfigurationUpdateHandler = {[weak self] button in // 1
            guard let self else {return}
            switch button.state {
            case .selected,.highlighted,[.selected,.highlighted]:
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5,initialSpringVelocity: 0.5,options: .curveEaseIn) {
                            button.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                        }completion: { _ in
                            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5,initialSpringVelocity: 0.5,options: .curveEaseIn){
                                button.transform = CGAffineTransform(scaleX: 1, y: 1)
                            }
                        }
            default: break
            }
        }
        self.configurationUpdateHandler = handler
        self.configuration = config
    }
    required init?(coder: NSCoder) {
        fatalError("Don't use Storyboard")
    }
//    @MainActor override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        Task{
//            self.transform = CGAffineTransform(scaleX: 1, y: 1 )
//            UIView.animate(withDuration: 0.4,delay: 0,options: .curveLinear) {
//                self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
//            }
//        }
//    }
//    @MainActor override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        Task{
//            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
//            UIView.animate(withDuration: 0.4, delay: 0, options: .curveLinear) {
//                self.transform = CGAffineTransform(scaleX: 1, y: 1 )
//            }
//        }
//    }
//    @MainActor override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        Task{
//            self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
//            UIView.animate(withDuration: 0.4, delay: 0, options: .curveLinear) {
//                self.transform = CGAffineTransform(scaleX: 1, y: 1 )
//            }
//
//        }
//    }
}
