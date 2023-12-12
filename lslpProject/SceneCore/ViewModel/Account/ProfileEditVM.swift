//
//  ProfileVM.swift
//  lslpProject
//
//  Created by 김태윤 on 12/12/23.
//

import Foundation
import Combine
final class ProfileEditVM: ObservableObject{
    @Published var nick:String
    @Published var phoneNum:String
    @Published var birthDay:String
    let profileSubject: CurrentValueSubject<Data?,Never>
    init(nick:String,phoneNum:String? = nil,birthDay:String? = nil,profile:Data? = nil) {
        self.nick = nick
        self.phoneNum = phoneNum ?? ""
        self.birthDay = birthDay ?? ""
        self.profileSubject = CurrentValueSubject(profile)
    }
    func editProfile(){
        Task{
            do{
                try await NetworkService.shared.editProfile(nick: nick, phoneNum: phoneNum, birthDay: birthDay, profile: profileSubject.value)
            }catch{
                print(error)
            }
        }
    }
}
