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
//    lazy var boardPick = {
//        var config = UIListContentConfiguration.valueCell()
//        config.text = "Pick a board"
//        config.imageToTextPadding = 0
//        config.directionalLayoutMargins = .init(top: 4, leading: 0, bottom: 4, trailing: 0)
//        let view = UIListContentView( configuration: config)
//        let imageView = UIImageView(image: .init(systemName: "chevron.right"))
//        view.addSubview(imageView)
//        imageView.snp.makeConstraints { make in
//            make.centerY.equalToSuperview()
//            make.trailing.equalToSuperview().inset(16)
//        }
//        
//        return view
//    }()
    let boardPickLabel = UILabel()
    lazy var boardPick = UIListContentView.getPinInfoListCell(text:"Pick a board",label: boardPickLabel)
    lazy var tagTopic = UIListContentView.getPinInfoListCell(text: "Tag related topics")
    lazy var advancedSettings = UIListContentView.getPinInfoListCell(text: "Advanced settings")
    init(vm: CreatingPinInfoVM){
        self.vm = vm
        super.init(frame: .zero)
        var arr = [descriptionTextField,linkTextField,boardPick,tagTopic,advancedSettings]
        arr.forEach{addArrangedSubview($0)}
        self.spacing = 8
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
                        make.top.equalTo(view.snp.bottom).offset(2)
                        make.horizontalEdges.equalTo(view)
                }
        }
        for (idx,val) in [boardPick,tagTopic,advancedSettings].enumerated(){
            val.tag = idx + 1
            val.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(Self.tappedItem(_:))))
        }
//        boardPick.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(Self.tappedItem(_:))))
    }
    required init(coder: NSCoder) {
        fatalError("Don't use storyboard")
    }
    @objc func tappedItem(_ action: UITapGestureRecognizer){
        print(action.view?.tag ?? 0)
        
    }
}
final class PinInfoTextField: UIStackView{
    private(set) var output: Output
    private let label = UILabel()
    private let textField = UITextField()
    private let attr = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .regular)]
    init(explain:String,placeholder:String){
        self.output = Output(text: textField.rx.text.orEmpty)
        super.init(frame: .zero)
        self.addArrangedSubview(label)
        self.addArrangedSubview(textField)
        self.axis = .vertical
        self.distribution = .fillProportionally
        self.alignment = .fill
        self.spacing = 4
        label.text = explain
        textField.attributedPlaceholder = .init(string: placeholder, attributes: attr)
        textField.tintColor = .systemGreen
        label.font = .systemFont(ofSize: 14, weight: .regular)
//        let underlineView = UIView()
//        underlineView.backgroundColor = .black
//        self.addSubview(underlineView)
//        underlineView.snp.makeConstraints { make in
//            make.height.equalTo(0.5)
//            make.top.equalTo(textField.snp.bottom).offset(2)
//            make.horizontalEdges.equalTo(textField)
//        }
    }
    required init(coder: NSCoder) {
        fatalError("Don't use storyboard")
    }
    struct Input{
    }
    struct Output{
        let text: ControlProperty<String>
    }
}

extension UIListContentView{
    static func getPinInfoListCell(text:String,label:UILabel? = nil)->UIListContentView{
        var config = UIListContentConfiguration.valueCell()
        config.imageToTextPadding = 0
        config.attributedText = .init(string: text, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 17)])
        config.directionalLayoutMargins = .init(top: 4, leading: 0, bottom: 4, trailing: 0)
        let view = UIListContentView( configuration: config)
        let imageView = UIImageView(image: .init(systemName: "chevron.right",withConfiguration: UIImage.SymbolConfiguration(font: .boldSystemFont(ofSize: 16))))
        imageView.tintColor = .text
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
        }
        if let label{
            view.addSubview(label)
            label.textColor = .gray
            label.font = .systemFont(ofSize: 15)
            label.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.trailing.equalTo(imageView.snp.leading).inset(-8)
            }
        }
        return view
    }
}
