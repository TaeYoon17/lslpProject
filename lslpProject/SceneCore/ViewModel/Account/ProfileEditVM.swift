//
//  ProfileVM.swift
//  lslpProject
//
//  Created by 김태윤 on 12/12/23.
//

import Foundation
import Combine
import SwiftUI
final class ProfileEditVM: ObservableObject{
    let originUser: (any UserDetailProvider)
    @Published var isDifferentOccur:Bool = false
    @Published var user: (any UserDetailProvider)
    
    let profileSubject: CurrentValueSubject<Data?,Never>
    var originSubject = PassthroughSubject<(any UserDetailProvider),Never>()
    var subscription = Set<AnyCancellable>()
    init(user: (any UserDetailProvider),profile:Data? = nil) {
            self.originUser = user
        self.user = user
        self.profileSubject = CurrentValueSubject(profile)
    }
    deinit{
        print("ProfileEditVM 삭제")
    }
    func editProfile(){
//        Task{
//            do{
//                try await NetworkService.shared.editProfile(nick: nick, phoneNum: phoneNum, birthDay: birthDay, profile: profileSubject.value)
//            }catch{
//                print(error)
//            }
//        }
    }
    private func differentBinding(){
        $user.map{[weak self] in
                guard let self else{ return false }
                return ($0.nick != originUser.nick || $0.phoneNum != originUser.phoneNum || $0.birthDay != originUser.birthDay)
            }.assign(to: &$isDifferentOccur)
        $isDifferentOccur.sink { val in
            print(val)
        }.store(in: &subscription)
    }
    func save(){
        originSubject.send(user)
    }
}
