//
//  PinInfoDataView.swift
//  lslpProject
//
//  Created by 김태윤 on 12/2/23.
//

import SnapKit
import UIKit
import RxSwift
import RxCocoa
import SwiftUI
final class PinInfoDataView: UIStackView{
    weak var vm: CreatingPinInfoVM!{
        didSet{
            guard let vm else {return }
            binding()
        }
    }
    var disposeBag = DisposeBag()
    func binding(){
        disposeBag = DisposeBag()
        descriptionTextField.text.subscribe(on: MainScheduler.asyncInstance).bind(to: vm.description).disposed(by: disposeBag)
        linkTextField.text.subscribe(on: MainScheduler.asyncInstance).bind(to: vm.link).disposed(by: disposeBag)
        vm.board.bind(to: boardPickLabel.rx.text).disposed(by: disposeBag)
        vm.board.bind(with: self) { owner, boardName in
            owner.boardPickLabel.text = boardName.isEmpty ? "보드를 선택하세요" : boardName
            owner.boardPickLabel.textColor = boardName.isEmpty ? UIColor.systemRed : .gray
        }.disposed(by: disposeBag)
        vm.hashTags.bind(with: self) { owner, hashTags in
            if hashTags.isEmpty{
                owner.tagPickLabel.text = "해시 태그를 추가하세요"
            }else{
                let text = "#\(hashTags.first!)"
                owner.tagPickLabel.text = String(text.prefix(8)) + (text.count > 8 ? "..." : "")
            }
            owner.tagPickLabel.textColor = hashTags.isEmpty ? .systemRed : .gray
        }.disposed(by: disposeBag)
    }
    let descriptionTextField = PinInfoTextField(explain: "Description", placeholder: "Add a detailed description")
    let linkTextField = PinInfoTextField(explain: "Link", placeholder: "Add your link here",keyboard: .URL)
    let boardPickLabel = UILabel()
    lazy var boardPick = UIListContentView.getPinInfoListCell(text:"Pick a board",label: boardPickLabel)
    let tagPickLabel = UILabel()
    lazy var tagTopic = UIListContentView.getPinInfoListCell(text: "Tag related topics",label: tagPickLabel)
    
    init(vm: CreatingPinInfoVM){
        self.vm = vm
        super.init(frame: .zero)
        var arr = [descriptionTextField,linkTextField,boardPick,tagTopic]
        arr.forEach{addArrangedSubview($0)}
        self.spacing = 12
        self.axis = .vertical
        self.distribution = .fillProportionally
        self.alignment = .fill
        arr.removeLast()
        arr.forEach{ view in
            let underlineView = UIView()
                    underlineView.backgroundColor = .black
                    self.addSubview(underlineView)
                    underlineView.snp.makeConstraints { make in
                        make.height.equalTo(0.5)
                        make.top.equalTo(view.snp.bottom).offset(6)
                        make.horizontalEdges.equalTo(view)
                }
        }
        for (idx,val) in [boardPick,tagTopic].enumerated(){
            val.tag = idx + 1
            val.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(Self.tappedItem(_:))))
        }
        configureView()
        binding()
    }
    required init(coder: NSCoder) {
        fatalError("Don't use storyboard")
    }
    func configureView(){
        let underlineView = UIView()
                underlineView.backgroundColor = .black
                self.addSubview(underlineView)
         
        self.addSubview(tagTopic)
        self.tagTopic.snp.makeConstraints { make in
            make.top.equalTo(boardPick.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(boardPick)
        }
        underlineView.snp.makeConstraints { make in
            make.height.equalTo(0.5)
            make.top.equalTo(boardPick.snp.bottom).offset(6)
            make.horizontalEdges.equalTo(boardPick)
        }
        
        [boardPickLabel,tagPickLabel].forEach { $0.font = .systemFont(ofSize: 14, weight: .bold) }
    }
    @objc func tappedItem(_ action: UITapGestureRecognizer){
        guard let tag = action.view?.tag else {return}
        switch tag{
        case 1:
            print("boardPick")
            vm.detailSetting.onNext(.board)
        case 2:
            print("tagTopic")
            vm.detailSetting.onNext(.tag)
        case 3:
            print("advancedSettings")
        default:break
        }
    }
}
