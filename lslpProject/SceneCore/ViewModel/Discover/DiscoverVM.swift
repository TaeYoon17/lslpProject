//
//  DiscoverVM.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/29.
//

import Foundation
final class DiscoverVM: ObservableObject{
    @DefaultsState(\.userBoards) var boards
    @Published var boardItems:[DiscoverListItem] = [.init(boardName: "All...", pins: [])]
    init(){
        Task{
            try await getMyData()
        }
    }
    deinit{
        print("DiscoverVM은 걱정 말라구~")
    }
    func getMyData() async throws {
        var listItem:[DiscoverListItem] = []
        for board in boards{
            let pins = try await NetworkService.shared.hashTags(board.hashTags)
            let item = DiscoverListItem(boardName: board.name, pins: pins )
            listItem.append(item)
        }
        let list = listItem
        await MainActor.run {
            self.boardItems = list
        }
    }
}
struct DiscoverItem:Hashable{
    let name:String
    let pinnedImage:[String]
}
struct DiscoverListItem: Hashable{
    var boardName:String
    var pins:[Pin]
}
