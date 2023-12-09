//
//  CreatingBoardVC.swift
//  lslpProject
//
//  Created by 김태윤 on 12/9/23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
final class CreatingBoardVM{
    var board = Board()
    var disposeBag = DisposeBag()
    let name = BehaviorSubject(value: "")
    let isPrivacy = BehaviorSubject(value: false)
    init(){
        Observable.combineLatest(name,isPrivacy).bind { [weak self] (name, isprivacy) in
            guard let self else {return}
            board.name = name
            board.isPrivacy = isprivacy
            print(board)
        }.disposed(by: disposeBag)
    }
    func upload(){
        
    }
}
final class CreatingBoardVC:BaseVC{
    let vm = CreatingBoardVM()
    let scrollView = UIScrollView()
    lazy var titleView = BoardTitleView(vm: vm)
    lazy var privacyView = PrivacyView(vm: vm)
    lazy var stackView = {
        let arr = [titleView,privacyView]
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
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide.snp.width)
        }
    }
    override func configureNavigation() {
        navigationItem.title = "Crate board"
        navigationItem.leftBarButtonItem = .init(systemItem: .close)
        navigationItem.rightBarButtonItem = .init(systemItem: .done)
        navigationItem.leftBarButtonItem?.rx.tap.bind(with: self) { owner, _ in
            owner.closeAction()
        }.disposed(by: disposeBag)
    }
    override func configureView() {
        view.backgroundColor = .systemBackground
        scrollView.backgroundColor = .systemBackground
    }
}

extension UIStackView{
    func simpleConfiguration(){
        self.axis = .vertical
        self.distribution = .fill
        self.alignment = .fill
        self.spacing = 4
    }
}
