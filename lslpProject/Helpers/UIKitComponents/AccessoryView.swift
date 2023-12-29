//
//  AccessoryView.swift
//  lslpProject
//
//  Created by 김태윤 on 12/29/23.
//

import UIKit
import SnapKit
final class AccessoryView: UIToolbar{
    weak var textField:UITextField!
    init(textField:UITextField){
        self.textField = textField
        super.init(frame: .zero)
        barStyle = .default
        isTranslucent = true
        sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        doneButton.tintColor = .text
        setItems([flexSpace, doneButton], animated: false)
    }
    required init?(coder: NSCoder) {
        fatalError("Don't use storyboard")
    }
    @objc func doneButtonTapped() {
        // "완료" 버튼이 눌렸을 때의 동작 구현
        textField.resignFirstResponder()
    }
}
