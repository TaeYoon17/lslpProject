//
//  DefaultStates.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/24.
//

import Foundation
@propertyWrapper
struct DefaultsState<Value>{
    private var path: ReferenceWritableKeyPath<UserDefaults,Value>
    var wrappedValue: Value{
        get{
            UserDefaults.standard[keyPath: path]
        }
        set{
            UserDefaults.standard[keyPath: path] = newValue
        }
    }
    init(_ location:ReferenceWritableKeyPath<UserDefaults,Value>){
        self.path = location
    }
}
extension UserDefaults{
    var accessToken: String{
        get{ self.string(forKey: "accessToken") ?? "" }
        set{self.set(newValue,forKey: "accessToken")}
    }
    var refreshToken: String{
        get{ self.string(forKey: "refreshToken") ?? "" }
        set{self.set(newValue,forKey: "refreshToken")}
    }
    var navigationBarHeight:CGFloat{
        get{self.double(forKey: "navigationBarHeight")}
        set{self.set(newValue,forKey:  "navigationBarHeight")}
    }
}
