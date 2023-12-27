//
//  PinInfoVC.swift
//  lslpProject
//
//  Created by 김태윤 on 12/1/23.
//

import SnapKit
import UIKit
import RxSwift
import RxCocoa
final class PinInfoVC: BaseVC{
    let vm: CreatingPinInfoVM
    init(vm: CreatingPinInfoVM){
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("Don't use Story board")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        vm.detailSetting.subscribe(on: MainScheduler.asyncInstance).bind(with: self) { owner, detail in
            switch detail{
            case .board:
                let vc = PinInfoBoardVC()
                owner.navigationController?.pushViewController(vc, animated: true)
            case .tag:
                let vc = PinInfoTagVC()
                owner.navigationController?.pushViewController(vc, animated: true)
            }
        }.disposed(by: disposeBag)
    }
    let scrollView = UIScrollView()
    lazy var pinInfoView = PinInfoTitleView(vm: vm)
    lazy var pinDataView = PinInfoDataView(vm: vm)
    lazy var stackView = {
        let arr = [pinInfoView,pinDataView]
        let stView = UIStackView(arrangedSubviews: arr)
        arr.forEach {
            $0.snp.makeConstraints { make in
                make.width.equalToSuperview().inset(16)
            }
        }
        stView.axis = .vertical
        stView.distribution = .fillProportionally
        stView.alignment = .center
        stView.spacing = 32
        return stView
    }()
    lazy var bottomView = {
        let v = BottomView()
        v.vm = vm
        return v
    }()
    override func configureLayout() {
        view.addSubview(scrollView)
        view.addSubview(bottomView)
        scrollView.addSubview(stackView)
    }
    override func configureConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(4)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(bottomView.snp.top)
        }
        bottomView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(52)
        }
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide.snp.width)
        }
    }
    override func configureView() {
        scrollView.backgroundColor = .systemBackground
    }
    override func configureNavigation() {
        navigationItem.title = "Hello world"
    }
    
}

