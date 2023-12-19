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
        @State private var selectedIdx = 0
        @State private var profileImg = Image(systemName: "person.fill")
        @FocusState private var focusField: Field?
        @State private var isFocus: Bool = false
        
        var publisher: PassthroughSubject<ScrollType, Never>
        var tabbarItems:[String]
        var size:CGFloat = 40
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
                    searchField.zIndex(1)
                    if isFocus{
                        Text("Cancel").wrapBtn{
                            self.focusField = nil
                        }
                        .transition(.move(edge: .trailing).combined(with: .opacity).animation(.easeInOut(duration: 0.4)))
                        .zIndex(0)
                    }else{
                        HStack(content: {
                            Image(systemName: gridType.gridIcon).wrapBtn {
                                self.presentType = .sheet(.grid)
                            }
                            Image(systemName: "plus").wrapBtn {
                                
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
                    if value != nil{ publisher.send(.store) }
                    
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
            .wrapBtn { publisher.send(.profile) }
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

struct ViewOptionView:View {
    @Binding var selectedGrid: GridType
    @Environment(\.dismiss) var dismiss
    @State private var presentHeight: CGFloat = 0
    var body: some View {
        VStack(spacing: 16){
            EmptyView()
            HStack{
                Text("View options").font(.subheadline)
                Spacer()
            }
            ForEach(GridType.allCases,id:\.self){ type in
                Button(action: {
                    selectedGrid = type
                    dismiss()
                }, label: {
                    HStack{
                        Text(type.name)
                        Spacer()
                        if type == selectedGrid{
                            Image(systemName: "checkmark")
                        }
                    }.font(.title2.bold())
                        .backgroundStyle(.gray)
                })
            }.tint(.text)
            Button(action: {
                dismiss()
            }, label: {
                Text("Close").padding().background(.regularMaterial)
                    .clipShape(Capsule()).font(.title3).fontWeight(.semibold)
            }).tint(.text)
        }.padding(.horizontal)
            .background(GeometryReader{ proxy in
                Color.clear.onAppear(){
                    presentHeight = proxy.size.height
                }
            })
            .presentationDetents([.height(presentHeight + 44)])
            .presentationCornerRadius(16)
    }
}
