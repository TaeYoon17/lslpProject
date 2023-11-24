//
//  VideoUploadVC.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/21.
//

import SnapKit
import UIKit
import RxSwift
import RxCocoa
final class VideoUploadView: BaseView{
    weak var vm: VideoUploadVM!{
        didSet{
            guard let vm else {return}
            disposeBag = DisposeBag()
        }
    }
    var disposeBag = DisposeBag()
    lazy var closeBtn = CloseBtn()
    override func configureView() {
        self.backgroundColor = .systemBlue
    }
    override func configureLayout() {
        addSubview(closeBtn)
    }
    override func configureConstraints() {
        closeBtn.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(16)
        }
    }
    override func binding() {
        print("Hello world!!")
    }
}
final class CloseBtn: UIButton{
    init(){
        super.init(frame: .zero)
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "xmark")
        configuration.background.visualEffect = UIBlurEffect(style: .systemMaterialLight)
        configuration.cornerStyle = .capsule
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 18, weight: .heavy)
        self.configuration = configuration
    }
    required init?(coder: NSCoder) {
        fatalError("Don't use Storyboard")
    }
}
