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
        enum Field: Hashable { case search }
        typealias PresentType = ProfileView.PresentType
        @EnvironmentObject var vm: ProfileVM
        @Namespace private var sectionTransition
        @Binding var selected: Int
        @Binding var presentType:PresentType?
        @Binding var gridType: GridType
        @Binding var scrollType: ScrollType?
        @Binding var isTabArea: Bool
        var tabbarItems:[String]
        @State private var selectedIdx = 0
        @State private var profileImg = Image(systemName: "person.fill")
        @State private var isFocus: Bool = false
        @FocusState private var focusField: Field?
        let size:CGFloat = 44
        var body: some View{
            VStack(spacing:0){
                HStack{
                    profileNaviItem.opacity(isTabArea ? 1 : 0)
                    Spacer()
                    tabHeader
                    Spacer()
                    settingNaviItem.opacity(isTabArea ? 1 : 0)
                }.frame(height: size)
                    .zIndex(2)
                HStack{ // MARK: -- SearchView
                    searchField.zIndex(1)
                    if isFocus{
                        Text("Cancel").wrapBtn{
                            self.focusField = nil
                        }
                        .transition(.move(edge: .trailing).combined(with: .opacity).animation(.easeInOut(duration: 0.4)))
                        .zIndex(0)
                    }else{
                        HStack(content: {
                            if selected == 0{
                                Image(systemName: gridType.gridIcon).wrapBtn {
                                    self.presentType = .sheet(.grid)
                                }
                            }
                            Image(systemName: "plus").wrapBtn {
                                //                                addAction
                                App.Manager.shared.addAction.onNext(())
                            }
                        }).font(.system(size: 21,weight: .semibold))
                            .tint(.text)
                            .zIndex(2)
                        
                    }
                }
                .padding(.vertical,8)
            }.zIndex(4)
                .background(.background)
                .onChange(of: focusField, perform: { value in
                    withAnimation {
                        self.isFocus = value != nil ? true : false
                        if value != nil{ scrollType = .store}
                    }
                })
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
    var searchField: some View{
        HStack{
            Image(systemName: "magnifyingglass").imageScale(.medium).bold().wrapBtn {
                self.focusField = .search
            }
            TextField("Search", text: .constant(""))
                .font(.system(size: 18,weight: .regular))
                .tint(.text)
                .focused($focusField, equals: .search)
        }
        .padding(.all,8)
        .background(.regularMaterial).clipShape(Capsule())
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
            .wrapBtn { scrollType = .profile}
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

