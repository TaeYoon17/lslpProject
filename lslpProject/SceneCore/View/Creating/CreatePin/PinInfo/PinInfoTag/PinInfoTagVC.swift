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
    convenience init() {
        self.init(rootView: PinInfoTagView())
        //        self.rootView.dismiss = {[weak self] in
        //            self?.navigationController?.popViewController(animated: true)
        //        }
        
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
    @State private var tags:[Tag] = []
    @FocusState var focused:Bool
    @State private var tagName = ""
    @State private var isTapped = true
    var body:some View{
        ScrollView {
            
            
            VStack(spacing:18){
//                            BoardWriteC.HashTag(tags: $tags, tagName: $tagName, focused: $focused)
                VStack(alignment:.leading){
                    HStack{
                        Text("Hash Tags: \(tags.count )/5").font(.title2.bold())
                        Spacer()
                    }
                    VStack(alignment:.leading){
                        if !tags.isEmpty{ TagView(tags: $tags)
                        }
                        HStack(spacing:4){
                            Text("#")
                            TextField("Enter hash tags", text: $tagName).focused($focused)
                            Button{
                                guard !tagName.isEmpty else {return}
                                tags.append(Tag(text: tagName))
                                tagName = ""
                            }label: {
                                Text("Add").modifier(BoardWriteC.AddModi())
                            }.disabled(tagName.isEmpty)
                                .opacity(tagName.isEmpty ? 0.6 : 1)
                                .animation(.easeInOut, value: tagName.isEmpty)
                        }.font(.system(.title3,weight: .semibold))
                            .opacity(tags.count >= 5 ? 0.6 : 1)
                            .disabled(tags.count >= 5)
                        Divider().frame(height:2).background(.text)
                    }
                }.frame(maxWidth: .infinity)
                VStack{
                    HStack{
                        Text("My Hash Tags").font(.title.bold())
                        Spacer()
                    }
                }
                Spacer()
            }
            .padding(.horizontal)
        }
    }
}
