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
}
extension UserDefaults{
    var user: User?{
        get{
            guard let userData = self.data(forKey: "user") else {return nil}
            guard let user = try? JSONDecoder().decode(User.self, from: userData) else {return nil}
            return user
        }
        set{
            let userData = try? JSONEncoder().encode(newValue)
            self.set(userData, forKey: "user")
        }
    }
}
