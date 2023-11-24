//
//  BaseView.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/22.
//

import SnapKit
import UIKit

class BaseView: UIView{
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    init(){
        super.init(frame: .zero)
        configureLayout()
        configureConstraints()
        configureView()
        binding()
    }
    func configureLayout(){ }
    func configureConstraints(){ }
    func configureView(){ }
    func binding(){}
    required init?(coder: NSCoder) {
        fatalError("Don't use storyboard")
    }
}
