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
    @Published var profile: Data?
    @Published var updateImage: Bool = false
    var originSubject = PassthroughSubject<(any UserDetailProvider,Data?),Never>()
    var subscription = Set<AnyCancellable>()
    init(user: (any UserDetailProvider),profile:Data? = nil) {
        self.originUser = user
        self.user = user
        self.profile = profile
        differentBinding()
    }
    deinit{
        print("ProfileEditVM 삭제")
    }
    func editProfile(){
    }
    private func differentBinding(){
        $user.map{[weak self] in
            guard let self else{ return false }
            return ($0.nick != originUser.nick || $0.phoneNum != originUser.phoneNum || $0.birthDay != originUser.birthDay)
        }.combineLatest($updateImage).map{$0.0 || $0.1}.assign(to: &$isDifferentOccur)
    }
    func save(){
        originSubject.send((user,profile))
        Task{
            do{
                try await NetworkService.shared.editProfile(nick: user.nick ?? "", phoneNum: user.phoneNum, birthDay: user.birthDay, profile: profile)
            }catch{
                print(error)
            }
        }
    }
}
