//
//  StaggredGrid.swift
//  lslpProject
//
//  Created by 김태윤 on 12/20/23.
//

import SwiftUI

struct StaggredGrid<Content:View,T:  Hashable>:View {
    
    // 각각의 오브젝트를 배열에 맞게 반환
    var content: (T) -> Content
    var list : [T]
    var spacing: CGFloat
    var columns :Int
    init(columns: Int,showIndicators:Bool = false,spacing: CGFloat = 10,list:[T],@ViewBuilder content: @escaping (T) -> Content){
        self.content = content
        self.list = list
        self.spacing = spacing
        self.columns = columns
    }
    
    var body: some View {
        HStack(alignment: .top) {
            ForEach(setUpList(),id:\.self){ list in
                LazyVStack(spacing:spacing) {
                    ForEach(list,id:\.self){ object in
                        content(object)
                    }
                }
            }
        }
    }
    func setUpList()->[[T]]{
        var gridArray:[[T]] = Array(repeating: [], count: columns)
        var currentIdx = 0
        for object in list{
            gridArray[currentIdx].append(object)
            currentIdx = (currentIdx + 1) % columns
        }
        return gridArray
    }
}
