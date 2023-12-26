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
                    header
                    contentBody
                }
            }
            .interactiveDismissDisabled() // 스와이프로 dismiss 막는 모디파이어
            .scrollIndicators(.hidden)
            .padding(.horizontal)
            .toolbar(.visible, for: .navigationBar)
            .toolbarTitleDisplayMode(.inline)
            .navigationTitle("보드 생성")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Image(systemName: "xmark").wrapBtn {
                        dismissAction?()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Text("Done").font(.headline).wrapBtn {
                        vm.upload()
                        dismissAction?()
                    }.disabled(!vm.isUplodable)
                    .opacity(!vm.isUplodable ? 0.6 : 1)
                }
                ToolbarItem(placement: .keyboard) {
                    HStack{
                        Spacer()
                        Button("Done"){ focused = false }.font(.headline).tint(.text)
                    }
                }
            }
        }
    }
    func itemView(name: String,view: @escaping ()->some View)-> some View{
        VStack(alignment:.leading,spacing:4){
            Text(name).font(.subheadline)
            view().tint(.text)
        }
    }
}

//MARK: -- BODY 그외 바디
extension BoardCreateView{
    @ViewBuilder var contentBody: some View{
        VStack(spacing:8){
            itemView(name: "Board name") {
                TextField("Enter the board name", text: $vm.name).focused($focused)
                    .font(.system(.title3,weight: .semibold))
            }
            Divider().padding(.bottom,4)
            itemView(name: "Hash tags: \(vm.tags.count) / 5") {
                Group{
                    if !vm.tags.isEmpty{ TagView(tags: $vm.tags) }
                    HStack(spacing:4){
                        Text("#")
                        TextField("Enter hash tags", text: $tagName).focused($focused)
                        Button{
                            guard !tagName.isEmpty else {return}
                            vm.tags.append(Tag(text: tagName))
                            tagName = ""
                        }label: {
                            Text("Add").modifier(AddModifier())
                        }.disabled(tagName.isEmpty)
                        .opacity(tagName.isEmpty ? 0.6 : 1)
                        .animation(.easeInOut, value: tagName.isEmpty)
                    }.font(.system(.title3,weight: .semibold))
                        .opacity(vm.tags.count >= 5 ? 0.6 : 1)
                        .disabled(vm.tags.count >= 5)
                }
            }
            Divider().padding(.bottom,4)
            itemView(name: "작업") {
                sectretView
            }
        }
    }
}
extension BoardCreateView{//MARK: -- 비밀 모드 설정하는 뷰
    @ViewBuilder var sectretView: some View{
        Toggle(isOn: $vm.isPrivacy) {
            VStack(alignment:.leading) {
                Text("이 보드를 비밀 모드로 설정하기").font(.system(.title3,weight: .semibold))
                Text("회원님만 이 보드를 볼 수 있습니다.").font(.footnote).foregroundStyle(.secondary)
                    
            }
        }.padding(.trailing,4)
    }
}
fileprivate struct AddModifier: ViewModifier{
    func body(content: Content) -> some View {
        content.font(.subheadline).fontWeight(.semibold)
            .foregroundStyle(.white)
            .padding(.vertical,6)
            .padding(.horizontal,10)
            .background(Capsule().fill(Color.green))
            .contentShape(Capsule())
    }
}
