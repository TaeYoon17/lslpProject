//
//  ViewController.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/14.


import UIKit
import RxSwift
import Alamofire
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let myAuthenticator = MyAuthenticator()
        let authCredential = AuthCredential(expiration: Date(timeIntervalSinceNow: 60 * 120))
        let authInterceptor = AuthenticationInterceptor(authenticator: myAuthenticator,credential: authCredential)
    }

}

