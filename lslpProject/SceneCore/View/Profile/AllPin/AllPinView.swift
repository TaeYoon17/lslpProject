//
//  AllPinView.swift
//  lslpProject
//
//  Created by 김태윤 on 12/19/23.
//

import SwiftUI

struct AllPinView: View {
    @Binding var gridType: GridType
//    let images = ["ARKit","AsyncSwift","Collections","lgWin","rabbits","macOS","Metal"]
    @Binding var pins:[Pin]
    let nextAction:()->Void
    var body: some View {
        VStack{
            StaggredGrid(columns: gridType.gridColumns, list: pins) { pin in
//                    PinView(image: image)
                PinListView(pin: pin,columns: gridType.gridColumns).onAppear(){
                    if pins.last == pin{
                        print("wow world!!")
                        nextAction()
                    }
                }
            }
            Spacer()
        }
    }
}

#Preview {
    AllPinView(gridType: .constant(.compact),pins: .constant([]), nextAction: {
        print("hello world!!")
    })
}
