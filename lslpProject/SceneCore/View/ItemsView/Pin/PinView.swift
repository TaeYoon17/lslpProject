//
//  PinView.swift
//  lslpProject
//
//  Created by 김태윤 on 12/6/23.
//

import Foundation
import SwiftUI
extension PinView{
    enum PinViewPresent:String,Identifiable{
        var id:String{ UUID().uuidString }
        case more
        case addComment
    }
}
struct PinView: View{
    @EnvironmentObject var discoverVM: DiscoverVM
    @DefaultsState(\.navigationBarHeight) var naviHeight
    @Environment(\.dismiss) var dismiss
    @State var presentType: PinViewPresent? = nil
    let image: String
//    @State var tempImage = Image(image,bundle: nil)
    var body: some View{
        ScrollView{
            VStack{
                PinImageSlider(image: Image(image,bundle: nil))
                    .overlay(alignment:.top){
                        Rectangle()
                            .fill(Gradient(colors: [.black.opacity(0.2),.clear]))
                            .frame(height:naviHeight + 44)
                    }
                Group{
                    PinProfileBanner()
                    PinBottom()
                }
                .padding(.horizontal,16)
            }
            Divider().padding(.vertical,4)
            Section {
                Button{
                    presentType = .addComment
                }label: {
                    HStack{
                        Text("Add the first comment")
                        Spacer()
                    }.padding(.vertical,8)
                        .padding(.horizontal)
                        .overlay(content: {
                            Capsule().stroke(.secondary,lineWidth:2)
                        })
                        .padding(.horizontal,20)
                        .padding(.top,8)
                        .padding(.bottom)
                }.tint(.text)
            } header: {
                HStack(alignment: .center){
                    Text("What do you think?")
                    Spacer()
                    HStack(spacing:4){
                        Text("8")
                        Image(systemName: "heart")
                            .wrapBtn {
                                print("My Like!!")
                            }
                    }.font(.system(size: 18,weight:.semibold))
                }.padding(.horizontal).padding(.top)
                    .font(.headline)
            }
            Divider().padding(.vertical,4)
        }
        .offset(y: -naviHeight)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.visible, for: .navigationBar)
        .toolbarBackground(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    print("More...")
                } label: {
                    Image(systemName: "ellipsis")
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                }
            }
        }.sheet(item: $presentType) { type in
            switch type{
            case .more: AddCommentView()
            case .addComment: AddCommentView()
            }
        }
    }
}

#Preview(body: {
    NavigationStack {
        PinView(image: "Metal").environmentObject(DiscoverVM())
    }
})

