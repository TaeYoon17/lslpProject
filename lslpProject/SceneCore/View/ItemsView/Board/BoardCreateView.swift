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


final class BoardCreateVM: ObservableObject{
    
}
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
    var dismissAction: (() -> Void)?
    let width = UIScreen.current!.bounds.width / 3
    @State private var name = ""
    @State private var tagName = ""
    @State private var privateMode = false
    @State private var pickerPresent = false
    @State private var hashTags:[String] = []
    @State private var tags:[Tag] = []
    @FocusState var focused: Bool
    var defaultImage: Image? = nil
    var body: some View {
        NavigationView{
            ScrollView{
                VStack(spacing:24){
                    header
                    VStack(spacing:8){
                        itemView(name: "Board name") {
                            TextField("Enter the board name", text: $name).focused($focused)
                                .font(.system(.title3,weight: .semibold))
                                
                        }
                        Divider().padding(.bottom,4)
                        itemView(name: "Hash Tags") {
                            Group{
                                if !tags.isEmpty{
                                    TagView(maxLimit: 150, tags: $tags)
                                }
                                HStack(spacing:4){
                                    Text("#")
                                    TextField("Enter hash tags", text: $tagName).focused($focused)
                                    Button{
                                        guard !tagName.isEmpty else {return}
                                        tags.append(Tag(text: tagName))
                                        tagName = ""
                                    }label: {
                                        Text("Add")
                                            .font(.subheadline).fontWeight(.semibold)
                                            .foregroundStyle(.white)
                                            .padding(.vertical,6)
                                            .padding(.horizontal,10)
                                            .background(Capsule().fill(Color.green))
                                            .contentShape(Capsule())
                                    }.disabled(tagName.isEmpty)
                                    .opacity(tagName.isEmpty ? 0.6 : 1)
                                    .animation(.easeInOut, value: tagName.isEmpty)
                                }.font(.system(.title3,weight: .semibold))
                            }
                        }
                        Divider().padding(.bottom,4)
                        itemView(name: "작업") {
                            sectretView
                        }
                    }
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
                        dismissAction?()
                    }
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
            view()
        }
    }
    @ViewBuilder var header: some View{
        VStack(alignment: .center,spacing: 16){
            EditImageView(isPresented:$pickerPresent,size: .init(width: width + 100, height: width + 100), content: { state in
                switch state{
                case .empty:
                    if let defaultImage{
                        defaultImage.resizable().scaledToFit()
                    }else{
                        Image(systemName: "plus")
                            .font(.system(size: width * 0.66))
                    }
                case .failure(_ ): Image("plus").resizable().scaledToFill()
                case .loading(_): ProgressView()
                case .success(let img):
                    Image(uiImage: img).resizable(resizingMode: .stretch).scaledToFit()
                        .animToggler()
                        .onAppear(){
                            do{
                                //                                let imgData = try img.jpegData(maxMB: 1)
                                //                                vm.profile = imgData
                                //                                vm.updateImage = true
                            }catch{
                                print(error)
                            }
                        }
                }
            })
            .frame(width:  width,height: width)
            .background(.regularMaterial)
            .clipShape(Circle())
            Button(action: {
                pickerPresent = true
            }, label: {
                Text("Edit")
                    .font(.headline)
                    .padding(.vertical,4).padding(.horizontal,6)
            }).accent(background: .regularMaterial)
        }
    }
}
extension BoardCreateView{
    var sectretView: some View{
        Toggle(isOn: $privateMode) {
            VStack(alignment:.leading) {
                Text("이 보드를 비밀 모드로 설정하기").font(.system(.title3,weight: .semibold))
                Text("회원님만 이 보드를 볼 수 있습니다.").font(.footnote).foregroundStyle(.secondary)
                    
            }
        }.padding(.trailing,4)
    }
}
