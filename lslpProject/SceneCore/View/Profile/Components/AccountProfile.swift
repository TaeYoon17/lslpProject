//
//  ProfileView.swift
//  lslpProject
//
//  Created by 김태윤 on 12/6/23.
//

import SwiftUI
extension ProfileView{
    struct AccountProfile: View{
        @EnvironmentObject var vm: ProfileVM
        @Binding var presentType:PresentType?
        @State var emailFront:String = ""
        @State private var image = Image(systemName: "person.fill")
        private let size = CGSize(width: 120, height: 120)
        var body: some View{
            VStack{
                HStack{
                    Spacer()
                    Image(systemName: "gearshape.fill")
                        .imageScale(.large).bold()
                        .scaledToFit()
                        .frame(width: 48,alignment:.trailing)
                        .wrapBtn {
                            self.presentType = PresentType.fullscreen(.settings)
                        }
                }.frame(height: 44)
                    .padding(.horizontal)
                    .padding(.vertical,4)
                VStack(alignment:.center,spacing:8){
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(size)
                        .background(.thinMaterial)
                        .clipShape(Circle())
                    Text(vm.user.nick ?? "").font(.largeTitle.bold())
                    Label(vm.user.email, systemImage: "leaf.circle")
                    HStack{
                        (Text("\(vm.followers.count)").bold() + Text(" follwers")).wrapBtn {
                            print("Hello followers")
                        }
                        Text("\u{2022}")
                        (Text("\(vm.following.count)").bold() + Text(" following").bold())
                            .wrapBtn {
                                print("Hello following")
                            }
                    }.multilineTextAlignment(.center)
                    Button(action: {
                        self.presentType = PresentType.sheet(.profile)
                    }, label: {
                        Text("Edit profile")
                            .font(.headline)
                            .padding(.all,8)
                    }).accent(background: .ultraThickMaterial)
                        .padding(.top,8)
                }
            }
            .onReceive(vm.$profileImage) { uiimage in
                if let uiimage{
                    self.image = Image(uiImage: uiimage)
                }else{
                    self.image = Image(systemName: "person.fill")
                }
            }
        }
    }
}
