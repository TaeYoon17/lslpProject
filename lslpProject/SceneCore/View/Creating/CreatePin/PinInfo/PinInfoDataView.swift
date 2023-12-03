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
final class PinInfoDataView: UIStackView{
    weak var vm: CreatingPinInfoVM!
    let descriptionTextField = PinInfoTextField(explain: "Description", placeholder: "Add a detailed description")
    let  linkTextField = PinInfoTextField(explain: "Link", placeholder: "Add your link here")
    let boardPickLabel = UILabel()
    lazy var boardPick = UIListContentView.getPinInfoListCell(text:"Pick a board",label: boardPickLabel)
    lazy var tagTopic = UIListContentView.getPinInfoListCell(text: "Tag related topics")
    lazy var advancedSettings = UIListContentView.getPinInfoListCell(text: "Advanced settings")
    init(vm: CreatingPinInfoVM){
        self.vm = vm
        super.init(frame: .zero)
        var arr = [descriptionTextField,linkTextField,boardPick,tagTopic,advancedSettings]
        arr.forEach{addArrangedSubview($0)}
        self.spacing = 12
        self.axis = .vertical
        self.distribution = .fillProportionally
        self.alignment = .fill
        boardPickLabel.text = "Hello world!!"
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
        for (idx,val) in [boardPick,tagTopic,advancedSettings].enumerated(){
            val.tag = idx + 1
            val.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(Self.tappedItem(_:))))
        }
    }
    required init(coder: NSCoder) {
        fatalError("Don't use storyboard")
    }
    @objc func tappedItem(_ action: UITapGestureRecognizer){
        print(action.view?.tag ?? 0)
        
    }
}
