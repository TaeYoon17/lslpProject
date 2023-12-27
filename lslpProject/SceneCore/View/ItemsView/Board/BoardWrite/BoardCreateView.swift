//
//  BoardCreateView.swift
//  lslpProject
//
//  Created by 김태윤 on 12/26/23.
//
import UIKit
import SwiftUI
import RxSwift
import RxCocoa

final class BoardCreateVC: UIHostingController<BoardCreateView>{
    convenience init(){
        self.init(rootView: BoardCreateView())
        self.rootView.dismissAction = { [weak self] in
            self?.dismiss(animated: true)
        }
    }
    override func viewDidLoad() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
}

struct BoardCreateView:View {
    @StateObject var vm = BoardCreateVM()
    var dismissAction: (() -> Void)?
    let width = UIScreen.current!.bounds.width / 3
    @FocusState var focused: Bool
    @State private var tagName = ""
    @State var pickerPresent = false
    var defaultImage: Image? = nil
    var body: some View {
        NavigationView{
            ScrollView{
                VStack(spacing:24){
                    BoardWriteC.Header(pickerPresent: $pickerPresent, defaultImage: .constant(nil), width: width){ data in
                        self.vm.imageData = data
                    }
                    contentBody
                }
            }
            .scrollDismissesKeyboard(.interactively)
            .modifier(BoardWriteC.ToolbarModi(title: "보드 생성", isAble: $vm.isUplodable, leftAction: {
                dismissAction?()
            }, rightAction: {
                vm.upload()
                dismissAction?()
            }, keyboardAction: {
                focused = false
            }))
        }
    }
}

//MARK: -- BODY 그외 바디
extension BoardCreateView{
    @ViewBuilder var contentBody: some View{
        VStack(spacing:8){
            BoardWriteC.Name(name: $vm.name, focused: $focused)
            Divider().padding(.bottom,4)
            BoardWriteC.HashTag(tags: $vm.tags, tagName: $tagName, focused: $focused)
        }
    }
}


