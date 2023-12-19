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
    @State @MainActor private var scrollHeight:CGFloat = 0
    @State private var heights:[CGFloat] = [0,0]
    @State private var gridType:GridType = .compact
    let publisher: PassthroughSubject<ScrollType, Never> = PassthroughSubject()
    var body: some View{
        NavigationStack {
            ScrollViewReader { scrollProxy in
                ScrollView{
                    AccountProfile(presentType: $presentType).id(ScrollType.profile)
                        .environmentObject(vm)
                    SectionTabView(selectedIdx: $selectedIdx, scrollHeight: $scrollHeight,data: ["Pin","Boards"]){ items in
                        ForEach(items.indices,id:\.self){ idx in
                            if items[idx] == "Boards"{
                                BoardView()
                                    .tag(idx)
                            }else{
                                AllPinView(gridType: $gridType)
                                    .tag(idx)
                            }
                        }.background(GeometryReader { proxy in
                            Color.clear
                                .onAppear(){
                                    print(selectedIdx)
                                    if heights[selectedIdx] == 0{
                                        heights[selectedIdx] = max(800,proxy.frame(in: .local).height)
                                        self.scrollHeight = heights[selectedIdx]
                                    }
                                }
                                .onChange(of: selectedIdx,perform:{ newValue in
                                    Task{@MainActor in
                                        try await Task.sleep(for: .seconds(0.2))
                                        if heights[selectedIdx] == 0{ heights[selectedIdx] = max(800,proxy.frame(in: .local).height) }
                                        withAnimation(.easeInOut(duration: 0.4)) {
                                            self.scrollHeight = heights[selectedIdx]
                                        }
                                    }
                                })
                                .onChange(of: gridType, perform:{ grid in
                                    Task{@MainActor in
                                        try await Task.sleep(for: .seconds(0.1))
                                        heights[selectedIdx] = max(800,proxy.frame(in: .local).height)
                                        withAnimation(.easeInOut(duration: 0.4)) {
                                            self.scrollHeight = heights[selectedIdx]
                                        }
                                    }
                                })
                        })
                    }headerView:{ selectedIdx,items in
                        AccountTopHeader(selected: selectedIdx, presentType: $presentType, gridType: $gridType, publisher: publisher, tabbarItems: items,size: 44)
                            .padding(.top,4)
                            .environmentObject(vm)
                            .background(.background)
                            .id(ScrollType.store)
                    }
                    
                }
                .clipped()
                .scrollIndicators(.hidden)
                .onReceive(publisher, perform: { newValue in
                    withAnimation { scrollProxy.scrollTo(newValue, anchor: .top) }
                })
                .toolbar(.hidden, for: .navigationBar)
                .present(presentType: $presentType) { item in
                    switch item{
                    case .profile:
                        ProfileEditView(user:vm.user,profile: vm.imageData){
                            vm.user = $0
                            vm.imageData = $1
                        }.any()
                    case .grid:
                        ViewOptionView(selectedGrid: $gridType).any()
                    }
                }fullScreen: { item in
                    switch item{
                    case .settings: SettingView().any()
                    }
                }
            }
        }
        .onChange(of: selectedIdx, perform: { value in
            publisher.send(.store)
        })
    }
    //    }
}
//MARK: -- Present 대응
fileprivate extension View{
    func present/*<A:View,B:View>*/(presentType:Binding<ProfileView.PresentType?>,sheet:@escaping ((ProfileView.SheetType) -> AnyView),fullScreen:@escaping ((ProfileView.FullscreenType) -> AnyView))->some View{
        self.modifier(ProfileView.SheetModifier(presentType: presentType, sheet: sheet, fullScreen: fullScreen))
    }
    func any()->AnyView{
        AnyView(self)
    }
}
