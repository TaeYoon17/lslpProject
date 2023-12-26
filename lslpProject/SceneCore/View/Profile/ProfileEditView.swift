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
    @State var phoneNumber:String
    @State var date:Date
    @State var pickerPresent = false
    @State var isProfileImagePresented = false
    let defaultImage: Image?
    let width = UIScreen.current!.bounds.width / 3
    let userChanged: ((any UserDetailProvider,Data?) -> Void)?
    init(user: (any UserDetailProvider),profile:Data? = nil,userChanged: ((any UserDetailProvider,Data?) -> Void)?){
        let vm = ProfileEditVM(user: user,profile: profile)
        _vm = .init(wrappedValue: vm)
        self.userChanged = userChanged
        self._nick = State(initialValue: vm.originUser.nick ?? "")
        self._phoneNumber = State(initialValue: vm.originUser.phoneNum ?? "")
        let date = if let dateString = user.birthDay{ Date(yyyyMMdd: dateString) } else { Date() }
        _date = .init(initialValue: date)
        defaultImage = if let profile { Image(uiImage: UIImage.fetchBy(data: profile,size: CGSize(width: 360, height: 360))) }else{ nil }
    }
    var body: some View {
        NavigationStack {
            ScrollView {
                header
                profileInfos.padding(.horizontal)
            }
            .toolbar(content: {
                    ToolbarItem(placement: .topBarLeading) {
                        Image(systemName: "xmark").wrapBtn { dismiss() }
                    }
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        Text("Done").font(.headline).wrapBtn {
                            vm.save()
                            userChanged?(vm.user,vm.profile)
                            dismiss()
                        }.disabled(!vm.isDifferentOccur)
                    }
                })
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Profile")
        }
    }
    @ViewBuilder var header: some View{
        VStack(alignment: .center,spacing: 16){
            EditImageView(isPresented:$pickerPresent,cropType: .circle(.init(width: 300, height: 300)), content: { state in
                switch state{
                case .empty:
                    if let defaultImage{
                        defaultImage.resizable().scaledToFit()
                    }else{
                        Image(systemName: "person.fill")
                            .font(.system(size: width * 0.66))
                    }
                case .failure(_ ): Image("Metal").resizable().scaledToFill()
                case .loading(_): ProgressView()
                case .success(let img):
                    Image(uiImage: img).resizable(resizingMode: .stretch).scaledToFit()
                        .animToggler()
                        .onAppear(){
                            do{
                                let imgData = try img.jpegData(maxMB: 1)
                                vm.profile = imgData
                                vm.updateImage = true
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
    @ViewBuilder var profileInfos: some View{
        VStack(spacing:8){
            profileLabel(type: "Nick Name", placeHolder: "닉네임", text: $nick)
            Divider().padding(.bottom,4)
            profileLabel(type: "Phone", placeHolder: "전화번호", text: $phoneNumber,keyType: .numberPad)
            Divider().padding(.bottom,4)
            LabelNavi(label: "BirthDay") {
                NavItem("My BirthDay") {
                    DatePicker("생일", selection: $date,displayedComponents: .date)
                        .datePickerStyle(.compact).labelsHidden()
                }
            }
        }
        .onChange(of: nick, perform: { vm.user.nick = $0 })
        .onChange(of: phoneNumber, perform: { vm.user.phoneNum = $0 })
        .onChange(of: date) { vm.user.birthDay = $0.yyyyMMdd }
    }
    @ViewBuilder func profileLabel(type:String,placeHolder:String,text: Binding<String>,keyType: UIKeyboardType = .default)->some View{
        VStack(alignment: .leading,spacing: 4){
            Text(type).font(.subheadline)
            TextField(placeHolder, text: text)
                .keyboardType(keyType)
                .font(.system(.title3,weight: .semibold))
        }
    }
}

#Preview {
    NavigationStack {
//        ProfileEditView(user: )
    }
}
struct AnimationToggler:ViewModifier{
    @State var toggler: Bool = false
    func body(content: Content) -> some View {
        content
            .opacity(toggler ? 1 : 0)
            .transition(.opacity)
            .onAppear(){
                toggler = false
                withAnimation(.easeInOut(duration: 0.2)) { toggler = true }
            }
            .onDisappear(){
                toggler = false
        }
    }
}
extension View{
    func animToggler()->some View{
        self.modifier(AnimationToggler())
    }
}
