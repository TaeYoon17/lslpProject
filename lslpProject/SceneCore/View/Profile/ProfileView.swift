//
//  ProfileView.swift
//  lslpProject
//
//  Created by 김태윤 on 12/13/23.
//

import SwiftUI
import Combine
struct ProfileView: View{
    enum ScrollType:Hashable{
        case profile
        case store
    }
    private let vm = ProfileVM()
    @State private var selectedIdx = 0
    @Namespace var tabbarShow
    @State private var height:CGFloat = 0
    @State var presentType:PresentType? = nil
    @State private var scrollType:ScrollType = .profile
    let publisher: PassthroughSubject<ScrollType, Never> = PassthroughSubject()
    var body: some View{
        NavigationStack {
            GeometryReader{ geometry in
                let globalH = geometry.frame(in: .global).height
                ScrollViewReader { scrollProxy in
                    ScrollView{
                        AccountProfile(presentType: $presentType).id(ScrollType.profile)
                            .environmentObject(vm)
                        SectionTabView(selectedIdx: $selectedIdx, data: ["Pin","Boards"], height: globalH){ items in
                            ForEach(items.indices,id:\.self){ idx in
                                Text("Hello world\(idx)").tag(idx)
                            }
                        }headerView:{ selectedIdx,items in
                            AccountTopHeader(selected: selectedIdx, presentType: $presentType, publisher: publisher, tabbarItems: items,size: 48)
                                .padding(.vertical,4)
                        }.id(ScrollType.store)
                    }
                    .clipped()
                    .scrollIndicators(.hidden)
                    .onReceive(publisher, perform: { newValue in
                        withAnimation {
                            scrollProxy.scrollTo(newValue, anchor: .top)
                        }
                    })
                    .toolbar(.hidden, for: .navigationBar)
                    .present(presentType: $presentType) { item in
                        switch item{
                        case .profile:
                            ProfileEditView(user:vm.user){
                                print("클로져가 바로 발생한다.")
                                print($0)
                                vm.user = $0
                            }
                        }
                    }fullScreen: { item in
                        switch item{
                        case .settings: SettingView()
                        }
                    }
                }
            }
            .onChange(of: selectedIdx, perform: { value in
                publisher.send(.store)
            })
        }
    }
}
//MARK: -- Present 대응
fileprivate extension View{
    func present<A:View,B:View>(presentType:Binding<ProfileView.PresentType?>,sheet:@escaping ((ProfileView.SheetType) -> A),fullScreen:@escaping ((ProfileView.FullscreenType) -> B))->some View{
        self.modifier(ProfileView.SheetModifier(presentType: presentType, sheet: sheet, fullScreen: fullScreen))
    }
}
