//
//  PinInfoVC.swift
//  lslpProject
//
//  Created by 김태윤 on 12/1/23.
//

import SnapKit
import UIKit

final class PinInfoVC: BaseVC{
    let vm = CreatingPinInfoVM()
    let scrollView = UIScrollView()
    let imageView = UIImageView(image: .init(named: "picture_demo"))
    lazy var pinInfoView = PinInfoTitleView(vm: vm)
    lazy var pinDataView = PinInfoDataView(vm: vm)
    lazy var stackView = {
        let arr = [pinInfoView,pinDataView]
        let stView = UIStackView(arrangedSubviews: arr)
        arr.forEach { $0.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(16)
        } }
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        stView.axis = .vertical
        stView.distribution = .fillProportionally
        stView.alignment = .center
        stView.spacing = 32
        return stView
    }()
    let bottomView = BottomView()
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
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
}
class BottomView: BaseView{
    let btn = {
        let btn = UIButton()
        var config = UIButton.Configuration.plain()
        config.contentInsets = .init(top: 12, leading: 12, bottom: 12, trailing: 12)
        config.attributedTitle = .init("Create", attributes: .init([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .semibold)]))
        config.cornerStyle = .capsule
        config.baseBackgroundColor = .systemGreen
        config.background.backgroundColor = .systemGreen
        config.baseForegroundColor = .white
        btn.configuration = config
        return btn
    }()
    override func configureView() {
        let anim = btn.animationSnapshot.scaleEffect(ratio: 0.95)
        do{
            try btn.apply(animationSnapshot: anim)
        }catch{
            print(error)
        }
    }
    override func configureLayout() {
        addSubview(btn)
    }
    override func configureConstraints() {
        btn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16.5)
            make.centerY.equalToSuperview()
        }
    }
}
