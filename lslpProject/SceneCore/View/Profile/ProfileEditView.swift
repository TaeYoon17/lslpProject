//
//  ProfileView.swift
//  lslpProject
//
//  Created by 김태윤 on 12/12/23.
//

import SwiftUI

struct ProfileEditView: View {
    @Environment(\.dismiss) var dismiss
    @State var date = Date()
    var body: some View {
        NavigationStack {
            ScrollView {
                header
                profileInfos.padding(.horizontal)
            }
            .toolbar(content: {
                    ToolbarItem(placement: .topBarLeading) {
                        Image(systemName: "xmark").wrapBtn {
                            dismiss()
                        }
                    }
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        Text("Done").font(.headline).wrapBtn {
                            print("wow world")
                        }
                    }
                })
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Profile")
        }
    }
    @ViewBuilder var header: some View{
        VStack(alignment: .center,spacing: 16){
            Image("Metal")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .scaleEffect(x: 1.2,y:1.2)
                .background(.red)
                .clipShape(Circle())
                .frame(width:  UIScreen.current!.bounds.width / 3)
            Button(action: {
            }, label: {
                Text("Edit")
                    .font(.headline)
                    .padding(.vertical,4).padding(.horizontal,6)
            }).accent(background: .regularMaterial)
        }
    }
    @ViewBuilder var profileInfos: some View{
        VStack(spacing:8){
            profileLabel(type: "Name", placeHolder: "고랙", text: .constant("AFSAD"))
            Divider().padding(.bottom,4)
            profileLabel(type: "NickName", placeHolder: "변경 닉네임", text: .constant("빈츠"))
            Divider().padding(.bottom,4)
            profileLabel(type: "BirthDay", placeHolder: "내 생일", text: .constant("wow world"))
            Divider().padding(.bottom,4)
            LabelNavi(label: "BirthDay") {
                NavItem("My Date") {
                    DatePicker("생일", selection: $date,displayedComponents: .date).datePickerStyle(.compact).labelsHidden()
                }
            }
        }
    }
    @ViewBuilder func profileLabel(type:String,placeHolder:String,text: Binding<String>)->some View{
        VStack(alignment: .leading,spacing: 4){
            Text(type).font(.subheadline)
            TextField("asfdasdf", text: text)
                .font(.system(.title3,weight: .semibold))
        }
    }
}

#Preview {
    NavigationStack {
        ProfileEditView()
    }
}
extension UIWindow {
    static var current: UIWindow? {
        for scene in UIApplication.shared.connectedScenes {
            guard let windowScene = scene as? UIWindowScene else { continue }
            for window in windowScene.windows {
                if window.isKeyWindow { return window }
            }
        }
        return nil
    }
}


extension UIScreen {
    static var current: UIScreen? {
        UIWindow.current?.screen
    }
}
