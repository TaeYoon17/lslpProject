//
//  ProfileVM.swift
//  lslpProject
//
//  Created by 김태윤 on 12/12/23.
//

import Foundation
import Combine
final class ProfileVM:ObservableObject{
    init(){
        Task{
            do{
                try await NetworkService.shared.getMyProfile()
            }catch{
                print(error)
            }
        }
    }
}
