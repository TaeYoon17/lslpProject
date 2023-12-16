//
//  ProfileVM.swift
//  lslpProject
//
//  Created by 김태윤 on 12/12/23.
//

import Foundation
import Combine
import UIKit
final class ProfileVM:ObservableObject{
    @Published var user:(any UserDetailProvider) = ProfileResponse(posts: [], followers: [], following: [], _id: "", email: "")
    @Published var followers:[User] = []
    @Published var following:[User] = []
    @Published var boards:[Board] = []
    @Published var pins:[PinPost] = []
    @Published var imagePath:String = ""
    @Published var profileImage: UIImage?
    var imageData: Data?{
        didSet{
            if let imageData{
                profileImage = UIImage.fetchBy(data: imageData,size: .init(width: 360, height: 360))
            }else{
                profileImage = nil
            }
        }
    }
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
                response.profile
                if let profile = response.profile{
                    imageData = try await NetworkService.shared.getImageData(imagePath: profile)
                }
            }catch{
                print(error)
            }
        }
    }
}
