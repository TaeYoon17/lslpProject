//
//  BoardEditView.swift
//  lslpProject
//
//  Created by 김태윤 on 12/26/23.
//

import SwiftUI
import Combine

struct BoardEditView:View {
    let width = UIScreen.current!.bounds.width / 3
    @Environment(\.dismiss) var dismiss
    @StateObject var vm :BoardEditVM
    @State private var name = ""
    @State private var tagName = ""
    @State private var privateMode = false
    @State private var pickerPresent = false
    @FocusState private var focused:Bool
    @State var defaultImage: Image? = nil
    init(_ board: Board){
        _vm = StateObject(wrappedValue: BoardEditVM(board))
    }
    var body: some View {
        NavigationView {
            ScrollView{
                VStack(spacing:24){
                    BoardWriteC.Header(pickerPresent: $pickerPresent, defaultImage: $defaultImage, width: width) { data in
                        vm.imageData = data
                        focused = false
                    }.presentationBackground(.clear)
                    contentBody
                }
            }
            .scrollDismissesKeyboard(.interactively)
            .modifier(BoardWriteC.ToolbarModi(title: "보드 수정", isAble: $vm.isUplodable, leftAction: {
                dismiss()
            }, rightAction: {
                vm.upload()
                dismiss()
            }, keyboardAction: {
                focused = false
            }))
            .task{
                if let imageData = vm.originBoard.data,let uiimage = UIImage(data: imageData){
                    withAnimation {
                        self.defaultImage = Image(uiImage: uiimage)
                    }
                }
            }
        }
    }

}
extension BoardEditView{
    @ViewBuilder var contentBody: some View{
        VStack(spacing:8){
            BoardWriteC.Name(name: $vm.name, focused: $focused)
            Divider().padding(.bottom,4)
            BoardWriteC.HashTag(tags: $vm.tags, tagName: $tagName, focused: $focused)
            Divider().padding(.bottom,4)
            BoardWriteC.Delete {
                vm.delete()
                dismiss()
            }
        }
    }
}
