//
//  ProfileView.swift
//  lslpProject
//
//  Created by 김태윤 on 12/6/23.
//

import SwiftUI
extension AccountView{
    struct AccountProfile: View{
        @Binding var presentType:PresentType?
        var body: some View{
            VStack{
                HStack{
                    Spacer()
                    Image(systemName: "gearshape.fill")
                        .imageScale(.large).bold()
                        .scaledToFit()
                        .frame(width: 48,alignment:.trailing)
                        .wrapBtn {
                            presentType = .settings
                        }
                }.frame(height: 44)
                    .padding(.horizontal)
                    .padding(.vertical,4)
                VStack(alignment:.center,spacing:8){
                    Image("lgWin")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120,height: 120)
                        .background(.thinMaterial)
                        .clipShape(Circle())
                    Text("태윤 김").font(.largeTitle.bold())
                    Label("xoqkdrnl99", systemImage: "leaf.circle")
                    HStack{
                        Text("0 follwers")
                        Text("\u{2022}")
                        Text("4 follwers").bold()
                    }.multilineTextAlignment(.center)
                    Button(action: {
                        print("EditProfile")
                    }, label: {
                        Text("Edit profile")
                            .font(.headline)
                            .padding(.all,8)
                    }).accent(background: .ultraThickMaterial)
                        .padding(.vertical,8)
                }
            }
        }
    }
}
