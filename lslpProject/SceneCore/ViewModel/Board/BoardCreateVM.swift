//
//  BoardCreateVM.swift
//  lslpProject
//
//  Created by 김태윤 on 12/26/23.
//

import Foundation
import Combine
final class BoardCreateVM: BoardWriteVM{
    override init(){
        super.init()
        $name.map{!$0.isEmpty}.assign(to: &$isUplodable)
    }
    override func upload(){
//        MARK: -- 업로드 네트워크
        Task{
            var boardPost = BoardPost(board: board)
            do{
                let res = try await NetworkService.shared.post(boardPost: boardPost)
                print(res)
            }catch{
                guard let networkError: Err.NetworkError = error as? Err.NetworkError else {
                    print(error)
                    return
                }
                print("오류 찾기")
                if networkError == .epiredRefreshToken{
                    
                }
            }
        }
    }
}
