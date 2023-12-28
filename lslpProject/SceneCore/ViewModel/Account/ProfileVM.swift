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
    @DefaultsState(\.userID) var userID
     var user:(any UserDetailProvider) = ProfileResponse(posts: [], followers: [], following: [], _id: "", email: "")
    @MainActor @Published var followers:[User] = []
    @MainActor @Published var following:[User] = []
    @MainActor @Published var boards:[Board] = []
    @MainActor @Published var pins:[PinPost] = []
    @Published var imagePath:String = ""
    @MainActor @Published var profileImage: UIImage?
    var imageData: Data?{
        didSet{
            Task{@MainActor in
                if let imageData{
                    profileImage = UIImage.fetchBy(data: imageData,size: .init(width: 360, height: 360))
                }else{
                    profileImage = nil
                }
            }
        }
    }
    init(){
        profileResponse()
    }
    private func profileResponse(){
        Task{[weak self] in
            guard let self else {return}
            do{
                let response = try await NetworkService.shared.getMyProfile()
                if let profile = response.profile{
                    imageData = try await NetworkService.shared.getImageData(imagePath: profile)
                }
                self.userID = response._id
                let boards = try await NetworkService.shared.getUserBoard()
                App.Manager.shared.updateBoards(boards: boards)
                await MainActor.run { [weak self] in
                    guard let self else {return}
                    self.user = response
                    self.boards = boards
                    self.followers = response.followers
                    self.following = response.following
                }
            }catch{
                print(error)
            }
        }
    }
}
