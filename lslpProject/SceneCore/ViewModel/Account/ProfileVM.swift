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
    @MainActor @Published var pins:[Pin] = []
    @Published var imagePath:String = ""
    @MainActor @Published var profileImage: UIImage?
    private var nextPin:String? = nil
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
                await MainActor.run { [weak self] in
                    guard let self else {return}
                    self.user = response
                    self.followers = response.followers
                    self.following = response.following
                }
                let boards = try await NetworkService.shared.getUserBoard()
                let (pins,nextPin) = try await NetworkService.shared.getUserPins(next: nextPin)
                App.Manager.shared.updateBoards(boards: boards)
                await MainActor.run {[weak self] in
                    guard let self else {return}
                    self.boards = boards
                    self.pins.append(contentsOf: pins)
                    self.nextPin = nextPin
                }
            }catch{
                print(error)
            }
        }
    }
    func userPin(){
        guard nextPin != "0" else {return}
        Task{
            let (pins,nextPin) = try await NetworkService.shared.getUserPins(next: nextPin)
            await MainActor.run {[weak self] in
                guard let self else {return}
                self.pins.append(contentsOf: pins)
                self.nextPin = nextPin
            }
        }
    }
}
