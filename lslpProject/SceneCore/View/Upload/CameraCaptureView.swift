//
//  CameraCaptureVC.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/21.
//

import SnapKit
import UIKit
import RxSwift
import RxCocoa
final class CameraCaptureView: BaseView{
    var disposeBag = DisposeBag()
    weak var vm: CameraCaptureVM!{
        didSet{
            guard let vm else {return}
            disposeBag = DisposeBag()
            let tapped = closeBtn.rx.tap
            let observables = vm.outAction(.init(closeTapped: tapped))
            observables.viewFinderImage.map {$0.uiImage }.subscribe(on: MainScheduler.instance)
            .bind(to: viewFinderImageView.rx.image)
                .disposed(by: disposeBag)
            bindingViewFinderLoading(observables.viewFinderImage)
        }
    }
    override init(){
        CameraService.shared.previewStart()
        super.init()
    }
    deinit{ CameraService.shared.previewStop() }
    required init?(coder: NSCoder) { fatalError( "Don't use storyboard") }
    let viewFinderImageView = UIImageView()
    let closeBtn = CloseBtn()
    var maskLayer: CALayer?
    @MainActor lazy var activityIndicator: UIActivityIndicatorView = { // indicator가 사용될 때까지 인스턴스를 생성하지 않도록 lazy로 선언
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = UIActivityIndicatorView.Style.large // indicator의 스타일 설정, large와 medium이 있음
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        Task{
            activityIndicator.center = viewFinderImageView.center
        }
        return activityIndicator
    }()
    override func configureView() {
        viewFinderImageView.contentMode = .scaleAspectFill
        viewFinderImageView.clipsToBounds = true
        maskLayer = CALayer()
        maskLayer?.backgroundColor = UIColor.systemBackground.cgColor
        Task{ @MainActor in
            maskLayer?.frame = viewFinderImageView.bounds
            viewFinderImageView.layer.addSublayer(maskLayer!)
            viewFinderImageView.layer.cornerRadius = 16
            viewFinderImageView.layer.cornerCurve = .circular
        }
    }
    override func configureLayout() {
        self.addSubview(viewFinderImageView)
        self.addSubview(activityIndicator)
        self.addSubview(closeBtn)
    }
    override func configureConstraints() {  
        viewFinderImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        activityIndicator.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        closeBtn.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(16)
        }
    }
}
