//
//  TempAlbumVC.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/29.
//

import UIKit
import SnapKit
import RxSwift
final class CreatingPinVC: BaseVC{
    let vm = CreatingPinVM()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    lazy var pinCreatingBottomView = PinCreatingBottomView(vm:vm)
    lazy var albumSelector = AlbumSelectorView(vm: vm)
    
    var dataSource: DataSource!
    override func viewDidLoad() {
        super.viewDidLoad()
        albumSelector.backgroundColor = .systemRed
        vm.openAlbumSelector.debounce(.milliseconds(200), scheduler: MainScheduler.instance).bind(with: self) { owner, val in
                UIView.animate(withDuration: 0.33) {
                    owner.albumSelectorDrawer(isOpen: val)
                }
        }.disposed(by: disposeBag)
        vm.selectedAlbums.map{$0.isEmpty}.debounce(.milliseconds(200), scheduler: MainScheduler.instance).bind(with: self) { owner, isEmpty in
            Task{@MainActor in
                if isEmpty{
                    owner.pinConstraint?.deactivate()
                    owner.bottomConstraint?.activate()
                    owner.collectionView.layoutIfNeeded()
                    try await Task.sleep(for: .seconds(0.2))
                }
                UIView.animate(withDuration: 0.3) {
                    owner.imageSelectorDrawer(isEmpty: isEmpty)
                }completion: { _ in
                    if !isEmpty{
                        owner.pinConstraint?.activate()
                        owner.bottomConstraint?.deactivate()
                        owner.collectionView.layoutIfNeeded()
                    
                    }
                }
            }
        }.disposed(by: disposeBag)
        //MARK: -- Right Navigation Item Action
        navigationItem.rightBarButtonItem?.rx.tap.bind(with: self) { owner, _ in
            let pinInfoVM = CreatingPinInfoVM(owner.vm)
            let vc = PinInfoVC(vm: pinInfoVM)
            owner.navigationController?.pushViewController(vc, animated: true)
        }.disposed(by: disposeBag)
    }
    var pinConstraint:Constraint?
    var bottomConstraint: Constraint?
    override func configureLayout() {
        view.addSubview(collectionView)
        view.addSubview(pinCreatingBottomView)
        view.addSubview(albumSelector)
    }
    override func configureConstraints() {
        pinCreatingBottomView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(88)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        collectionView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            self.pinConstraint = make.bottom.equalTo(pinCreatingBottomView.snp.top).constraint
            self.bottomConstraint = make.bottom.equalTo(view.safeAreaLayoutGuide).constraint
        }
        
        albumSelector.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
        pinConstraint?.deactivate()
        bottomConstraint?.activate()
    }
    override func configureNavigation() {
        navigationController?.navigationBar.backgroundColor = .systemBackground
        navigationItem.leftBarButtonItem = .init(systemItem: .cancel)
        let button = AlbumNaviTitileButton()
        button.isTappedSubject.bind(to: vm.openAlbumSelector).disposed(by: disposeBag)
        navigationItem.titleView = button
        navigationItem.leftBarButtonItem?.rx.tap.bind(with: self) { owner, _ in
            owner.closeAction()
        }.disposed(by: disposeBag)
        navigationItem.rightBarButtonItem = .init(title: "Next")
        
        self.isModalInPresentation = true
    }
    
    override func configureView() {
        view.backgroundColor = .systemBackground
        configureCollectionView()
        pinCreatingBottomView.isHidden = true
        albumSelector.isHidden = true
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Task{@MainActor in
            try await Task.sleep(for: .seconds(0.2))
            pinCreatingBottomView.isHidden = false
            albumSelector.isHidden = false
        }
    }
}
extension CreatingPinVC{
    func albumSelectorDrawer(isOpen: Bool){
        let bounds = albumSelector.bounds
        let height = bounds.height
        let ny = bounds.origin.y
        albumSelector.bounds = .init(origin: bounds.origin, size: .init(width: bounds.width, height: height - ny))
        albumSelector.transform = .init(translationX: 0, y: isOpen ? 0: -height + ny)
    }
    func imageSelectorDrawer(isEmpty: Bool){
        let height = self.pinCreatingBottomView.bounds.height + 32
        pinCreatingBottomView.transform = .init(translationX: 0, y: isEmpty ? height : 0)
    }
}


