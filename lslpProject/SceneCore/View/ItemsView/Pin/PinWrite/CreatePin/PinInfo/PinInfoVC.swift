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
    deinit{
        print("PinInfoVC Deinit!!")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        vm.detailSetting.subscribe(on: MainScheduler.asyncInstance).bind(with: self) { owner, detail in
            switch detail{
            case .board:
                let vm = PinInfoBoardVM(itemID: try? owner.vm.boardID.value(),itemName: try! owner.vm.board.value())
                let vc = PinInfoBoardVC()
                vc.vm = vm
                vm.selectedItemID.bind(to: owner.vm.boardID).disposed(by: owner.disposeBag)
                vm.selectedItemName.bind(to: owner.vm.board).disposed(by: owner.disposeBag)
                owner.navigationController?.pushViewController(vc, animated: true)
            case .tag:
                let vc = PinInfoTagVC(vm: owner.vm)
                owner.navigationController?.pushViewController(vc, animated: true)
            }
        }.disposed(by: disposeBag)
        vm.isCreateAble.bind(to:navigationItem.rightBarButtonItem!.rx.isEnabled).disposed(by: disposeBag)
        navigationItem.rightBarButtonItem?.rx.tap.bind(with: self, onNext: { owner, _ in
            Task{
                await owner.vm.upload()
                owner.dismiss(animated: true)
            }
        }).disposed(by: disposeBag)
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
    override func configureLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
    }
    override func configureConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(4)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
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
        navigationItem.title = "Pin Info"
        navigationItem.rightBarButtonItem = .init(systemItem: .done)
        
    }
    
}

