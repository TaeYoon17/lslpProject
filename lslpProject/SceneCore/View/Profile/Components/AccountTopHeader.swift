//
//  AccountTopHeader.swift
//  lslpProject
//
//  Created by 김태윤 on 12/6/23.
//

import SwiftUI
import Combine
extension ProfileView{
    struct AccountTopHeader:View{
        @EnvironmentObject var vm: ProfileVM
        typealias PresentType = ProfileView.PresentType
        @Namespace private var sectionTransition
        @Binding var selected: Int
        @Binding var presentType:PresentType?
        @State private var selectedIdx = 0
        @State private var profileImg = Image(systemName: "person.fill")
        var publisher: PassthroughSubject<ScrollType, Never>
        var tabbarItems:[String]
        var size:CGFloat = 48
        var body: some View{
            VStack(spacing:0){
                HStack{
                    profileNaviItem
                    Spacer()
                    tabHeader
                    Spacer()
                    settingNaviItem
                }.frame(height: size)
                HStack{
                    Text("TextField")
                    Spacer()
                    HStack(spacing: 4){
                        Image(systemName:"arrow.up.arrow.down")
                        Image(systemName: "plus")
                    }.font(.system(size: 18,weight: .semibold))
                }.frame(height: size)
            }
        }
        var tabHeader:some View{
            HStack(spacing:16){
                ForEach(tabbarItems.indices,id:\.self){ idx in
                    TopTabbarItem(name: tabbarItems[idx],
                                  isActive: idx == selectedIdx,
                                  namespace: sectionTransition,
                                  font:.system(size: 20,weight: .semibold)
                                  ,paddingHeight: 6,lineHeight: 4)
                    .wrapBtn {
                        withAnimation(.easeInOut) {
                            selected = idx
                        }
                    }
                }
            }.onChange(of: selected) { newValue in
                withAnimation(.easeInOut) {
                    selectedIdx = newValue
                }
            }
        }
    }
}
extension ProfileView.AccountTopHeader{
    var profileNaviItem: some View{
        profileImg
            .resizable()
            .scaledToFill()
            .frame(width: size)
            .background(.thinMaterial)
            .clipShape(Circle())
            .wrapBtn {
                publisher.send(.profile)
            }
            .onReceive(vm.$profileImage) { output in
                if let output{
                    profileImg = Image(uiImage: output)
                }else{
                    profileImg = Image(systemName: "person.fill")
                }
            }
    }
    var settingNaviItem: some View{
        Image(systemName: "ellipsis")
            .imageScale(.large).bold()
            .scaledToFit()
            .frame(width: size,alignment:.trailing)
            .wrapBtn {
                self.presentType = .fullscreen(.settings)
            }
    }
}
#Preview(body: {
    ProfileView()
})
