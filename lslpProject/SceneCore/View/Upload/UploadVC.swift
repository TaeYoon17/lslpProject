//
//  UploadVC.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/21.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
final class UploadVC: BaseVC{
    let vm = UploadVM()
    let videoUploadVM = VideoUploadVM()
    let cameraCaptureVM = CameraCaptureVM()
    var containerView = UIView()
    var bottomView = UIButton()
    enum UploadType{
        case capture
        case album
    }
    var nowType = UploadType.capture
    override func viewDidLoad() {
        super.viewDidLoad()
        videoUploadVM.uploadVM = self.vm
        cameraCaptureVM.uploadVM = self.vm
//        updateNowType()
        let res = vm.outputActor(.init())
        res.dismiss.subscribe(with: self){owner, dismiss in
            if dismiss{ owner.closeAction() }
        }.disposed(by: disposeBag)
        bottomView.addAction(.init(handler: { [weak self] _ in
            guard let self else {return}
            self.updateNowType()
        }), for: .touchUpInside)
        bottomView.backgroundColor = .systemRed
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateNowType()
    }
    deinit{ CameraService.shared.previewStop() }
    func updateNowType(){
        switch nowType {
        case .capture:
            let view = CameraCaptureView()
            view.vm = cameraCaptureVM
            setContainerView(view)
            nowType = .album
        case .album:
            let view = VideoUploadView()
            view.vm = videoUploadVM
            setContainerView(view)
            nowType = .capture
        }
    }
    override func configureView() {
        self.isModalInPresentation = true
        self.containerView.layer.cornerRadius = 16
        self.containerView.layer.cornerCurve = .circular
    }
    override func configureLayout() {
        view.addSubview(bottomView)
        view.addSubview(containerView)
    }
    override func configureConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(66)
        }
        bottomView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(66)
        }
    }
    override func configureNavigation() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @objc func dismissAction(){
        self.closeAction()
    }
    @MainActor func setContainerView(_ view: UIView){
        containerView.subviews.forEach { $0.removeFromSuperview() }
        containerView.addSubview(view)
        view.frame = containerView.bounds
        view.layer.cornerCurve = .continuous
        view.layer.cornerRadius = 16
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
