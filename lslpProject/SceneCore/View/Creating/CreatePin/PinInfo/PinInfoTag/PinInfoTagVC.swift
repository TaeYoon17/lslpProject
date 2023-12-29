//
//  PinInfoTagVC.swift
//  lslpProject
//
//  Created by 김태윤 on 12/9/23.
//

import UIKit
import SwiftUI
import SnapKit
import RxSwift
import RxCocoa

final class PinInfoTagVC:UIHostingController<PinInfoTagView>{
    convenience init(vm: CreatingPinInfoVM) {
        let pinInfoTagView = PinInfoTagView { tags  in
            vm.hashTags.onNext(tags)
        }
        self.init(rootView: pinInfoTagView)
    }
    override func viewDidLoad() {
        //        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationItem.title = "핀 태그"
    }
    deinit{
        print("PinInfoTagVC Deinit!!!")
    }
}
struct PinInfoTagView:View{
    //    var dismiss:(()->Void)?
    var changedTags:(([String]) -> Void)
    @MainActor @State var tags:[Tag] = []
    @MainActor @State private var usedHashTags:[Tag] = []
    @FocusState var focused:Bool
    @State private var tagName = ""
    @State private var isTapped = true
    @State private var isDuplicated = false
    var body:some View{
        ScrollView {
            VStack(spacing:12){
                VStack(alignment:.leading){
                    HStack{
                        Text("Hash Tags: \(tags.count )/5").font(.title2.bold())
                        Spacer()
                    }
                    VStack(alignment:.leading){
                        if !tags.isEmpty{ TagView($tags) }
                        HStack(spacing:4){
                            Text("#")
                            TextField("Enter hash tags", text: $tagName).focused($focused)
                            Button{
                                guard !tagName.isEmpty else {return}
                                guard !tags.map({$0.text}).contains(tagName) else {
                                    isDuplicated.toggle()
                                    return
                                }
                                defer{tagName = ""}
                                guard tags.count < 5 else {return}
                                tags.append(Tag(text: tagName))
                                
                            }label: {
                                Text("Add").modifier(BoardWriteC.AddModi())
                            }.disabled(tagName.isEmpty)
                                .opacity(tagName.isEmpty ? 0.6 : 1)
                                .animation(.easeInOut, value: tagName.isEmpty)
                        }.font(.system(.title3,weight: .semibold))
                            .opacity(tags.count >= 5 ? 0.6 : 1)
                            .disabled(tags.count >= 5)
                        Divider().frame(height:0.5).background(.regularMaterial)
                    }
                }.padding()
                .frame(maxWidth: .infinity)
                VStack(alignment:.leading){
                    HStack{
                        Text("My Board Hash Tags").font(.title2.bold())
                        Spacer()
                    }
                    if !usedHashTags.isEmpty{ 
                        TagView($usedHashTags,fontSize: 16,type: .append({ hashTag in
                            guard tags.count < 5 else {return}
                            guard !tags.map({$0.text}).contains(hashTag) else {
                                isDuplicated.toggle()
                                return
                            }
                            tags.append(Tag(text: hashTag))
                    })
                        )
                    }
                }.padding(.horizontal)
                .frame(maxWidth: .infinity)
                .onAppear(){
                    @DefaultsState(\.userHashTags) var tags
                    self.usedHashTags = tags.map{Tag(text: $0)}
                }
                .onChange(of: tags) { newValue in
                    changedTags(newValue.map{$0.text})
                }
                Spacer()
                .keyboardDismiss {
                    focused = false
                }
                .alert("중복된 태그 이름이 있어요!!", isPresented: $isDuplicated){
                    Text("Back").bold()
                }
//                {
////                    Alert(title: Text("중복된 태그 이름이 있어요!!"))
//                    Alert(title: Text("중복된 태그 이름이 있어요!!"), primaryButton: .cancel(), secondaryButton: .default(Text("wow")))
//                }
            }
        }
    }
}
