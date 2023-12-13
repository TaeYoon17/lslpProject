//
//  ProfileVM.swift
//  lslpProject
//
//  Created by 김태윤 on 12/12/23.
//

import Foundation
import Combine
final class ProfileVM:ObservableObject{
    @Published var user:(any UserDetailProvider) = ProfileResponse(posts: [], followers: [], following: [], _id: "", email: "")
    @Published var followers:[User] = []
    @Published var following:[User] = []
    @Published var boards:[Board] = []
    @Published var pins:[PinPost] = []
    @Published var imagePath:String = ""
//    @Published var nick:String = ""
//    @Published var phoneNumber:String = ""
//    @Published var email:String = ""

//    @Published var birthDay:String = ""
    init(){
        profileResponse()
    }
    private func profileResponse(){
        Task{
            do{
                let response = try await NetworkService.shared.getMyProfile()
                self.followers = response.followers
                self.following = response.following
                self.user = response
            }catch{
                print(error)
            }
        }
    }
}
