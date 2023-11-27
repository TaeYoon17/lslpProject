//
//  OnboardingVC.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/24.
//

import UIKit
import SnapKit

final class OnboardingVC:BaseVC{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpBtn.addAction(.init(handler: { [weak self] _ in
            let signUpVC = SignUpVC()
            let nav = UINavigationController(rootViewController: signUpVC)
            nav.modalPresentationStyle = .fullScreen
            self?.present(nav, animated: true)
        }), for: .touchUpInside)
        signInBtn.addAction(.init(handler: { [weak self] _ in
            let signInVC = SignInVC()
            let nav = UINavigationController(rootViewController: signInVC)
            self?.present(nav, animated: true)
        }), for: .touchUpInside)
    }
    let shadowView = {
        let v = UIView()
        v.backgroundColor = .clear
        let gradientLayer: CAGradientLayer = .init()
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        let colors: [CGColor] = [
           .init(red: 1, green: 1, blue: 1, alpha: 1),
           .init(red: 1, green: 1, blue: 1, alpha: 1),
           .init(red: 1, green: 1, blue: 1, alpha: 0.66),
           .init(red: 1, green: 1, blue: 1, alpha: 0.33),
           .init(red: 1, green: 1, blue: 1, alpha: 0.0)
        ]
//        gradientLayer.locations = [0.4,0.8]
        gradientLayer.colors = colors
        v.layer.addSublayer(gradientLayer)
        Task{ gradientLayer.frame = v.bounds }
        return v
    }()
    private let infoAnimView = InfoAnimView()
    private let signUpBtn = OnboardingBtn(text: "Sign up", textColor: .white, bgColor: .systemGreen)
    private let signInBtn = OnboardingBtn(text: "Log in", textColor: .black, bgColor: .lightGray)
    lazy var btnStView = {
        let arr = [signUpBtn,signInBtn]
        let stView = UIStackView(arrangedSubviews: arr)
        arr.forEach { btn in btn.snp.makeConstraints { make in make.height.equalTo(48) } }
        stView.axis = .vertical
        stView.spacing = 8
        stView.alignment = .fill
        stView.distribution = .fill
        return stView
    }()
    
    let logoImageView = UIImageView(image: UIImage(systemName: "leaf.circle",
                                                   withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 60, weight: .medium))))
    let descriptionView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.textAlignment = .center
        textView.text = "By continuing, you agree to Pinterest's Terms of Service and acknowledge you've read our Privacy Policy. Notice at collection"
        textView.font = .preferredFont(forTextStyle: .caption1)
        return textView
    }()
    let welcomeLabel = {
        let label = UILabel()
        label.text = "Welcome to Pinterest"
        label.font = .systemFont(ofSize: 28,weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    override func configureLayout() {
        [infoAnimView,shadowView,descriptionView,btnStView,welcomeLabel,logoImageView].forEach { view in
            self.view.addSubview(view)
        }
    }
    override func configureConstraints() {
        descriptionView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(8)
            make.horizontalEdges.equalToSuperview().inset(16.5)
            make.height.equalTo(66)
        }
        btnStView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16.5)
            make.bottom.equalTo(descriptionView.snp.top).inset(-16.5)
        }
        welcomeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(btnStView.snp.top).inset(-16.5)
            make.centerX.equalToSuperview()
        }
        logoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(welcomeLabel.snp.top).inset(-8)
        }
//        shadowView.snp.makeConstraints { make in
//            make.bottom.horizontalEdges.equalToSuperview()
//            make.top.equalTo(view.snp.centerY)
//        }
        infoAnimView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(logoImageView.snp.centerY)
        }
        shadowView.snp.makeConstraints { make in
            make.bottom.equalTo(logoImageView.snp.centerY)
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(view.snp.centerY)
        }
    }
    override func configureView() {
        view.backgroundColor = .systemBackground
        logoImageView.tintColor = .systemGreen
    }
    override func configureNavigation() {
        
    }
}

class OnboardingBtn:UIButton{
    init(text:String,textColor:UIColor,bgColor:UIColor){
        super.init(frame: .zero)
        var configuration = UIButton.Configuration.plain()
        configuration.baseBackgroundColor = bgColor
        configuration.background.backgroundColor = bgColor
        configuration.baseForegroundColor = textColor
        configuration.cornerStyle = .capsule
        configuration.titleAlignment = .center
        configuration.attributedTitle = .init(text, attributes: .init([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .semibold)]))
        self.configuration = configuration
        let animSnapshot = self.animationSnapshot.scaleEffect(ratio: 0.95)
        do{
            try self.apply(animationSnapshot: animSnapshot)
        }catch{
            print(error)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("Don't use storyboard")
    }
}
fileprivate final class InfoAnimView: UIView{
    let tempView = UIImageView(image: UIImage(named: "picture_demo"))
    init(){
        super.init(frame: .zero)
        addSubview(tempView)
        tempView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tempView.contentMode = .scaleAspectFill
        tempView.clipsToBounds = true
    }
    required init?(coder: NSCoder) {
        fatalError("Don't use storyboard")
    }
}
