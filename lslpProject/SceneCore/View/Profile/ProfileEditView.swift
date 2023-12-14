//
//  ProfileView.swift
//  lslpProject
//
//  Created by 김태윤 on 12/12/23.
//

import SwiftUI

struct ProfileEditView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var vm: ProfileEditVM
    @State var nick:String
    @State var birthDay:String
    @State var phoneNumber:String
    @State var date = Date()
    let userChanged: (((any UserDetailProvider)) -> Void)?
    init(user: (any UserDetailProvider),profile:Data? = nil,userChanged: (((any UserDetailProvider)) -> Void)?){
        let vm = ProfileEditVM(user: user)
        _vm = .init(wrappedValue: vm)
        self.userChanged = userChanged
        self._nick = State(initialValue: vm.originUser.nick ?? "")
        self._birthDay = State(initialValue: vm.originUser.birthDay ?? "")
        self._phoneNumber = State(initialValue: vm.originUser.phoneNum ?? "")
    }
    var body: some View {
        NavigationStack {
            ScrollView {
                header
                profileInfos.padding(.horizontal)
            }
            .onReceive(vm.originSubject, perform: { userChanged?($0) })
            .toolbar(content: {
                    ToolbarItem(placement: .topBarLeading) {
                        Image(systemName: "xmark").wrapBtn {
                            dismiss()
                        }
                    }
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        Text("Done").font(.headline).wrapBtn {
                            vm.save()
                            dismiss()
                        }
                    }
                })
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Profile")
        }
    }
    @ViewBuilder var header: some View{
        VStack(alignment: .center,spacing: 16){
            let width = UIScreen.current!.bounds.width / 2
            EditImageView(size: .init(width: width, height: width), content: { state in
                switch state{
                case .empty: Image("Metal").resizable().scaledToFill()
                case .failure(_ ): Image("Metal").resizable()
                case .loading(_ ):
                    ProgressView()
                case .success(let img):
                    Image(uiImage: img).resizable(resizingMode: .stretch).scaledToFill()
                        .onAppear(){
                            do{
                                let imgData = try img.jpegData()
                                vm.profileSubject.send(imgData)
                            }catch{
                                print(error)
                            }
                        }
                }
            })
            .scaleEffect(x:1.2,y:1.2)
            .clipShape(Circle())
            .frame(width:  width,height: width)
            
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
            profileLabel(type: "Nick Name", placeHolder: "닉네임", text: $nick)
            Divider().padding(.bottom,4)
            profileLabel(type: "Phone", placeHolder: "전화번호", text: $phoneNumber)
            Divider().padding(.bottom,4)
            profileLabel(type: "BirthDay", placeHolder: "내 생일", text: $birthDay)
            Divider().padding(.bottom,4)
            LabelNavi(label: "BirthDay") {
                NavItem("My BirthDay") {
                    DatePicker("생일", selection: $date,displayedComponents: .date).datePickerStyle(.compact).labelsHidden()
                }
            }
        }
        .onChange(of: nick, perform: { vm.user.nick = $0 })
        .onChange(of: birthDay, perform: { vm.user.birthDay = $0 })
    }
    @ViewBuilder func profileLabel(type:String,placeHolder:String,text: Binding<String>)->some View{
        VStack(alignment: .leading,spacing: 4){
            Text(type).font(.subheadline)
            TextField(placeHolder, text: text)
                .font(.system(.title3,weight: .semibold))
        }
    }
}

#Preview {
    NavigationStack {
//        ProfileEditView(user: )
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
