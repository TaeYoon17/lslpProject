//
//  ProfileView.swift
//  lslpProject
//
//  Created by 김태윤 on 12/13/23.
//

import SwiftUI
import Combine
extension ProfileView{
    enum ScrollType:Hashable{
        case profile
        case store
    }
}
struct ProfileView: View{
    @StateObject var vm = ProfileVM()
    @State private var selectedIdx = 0
    @Namespace var tabbarShow
    //    @State private var height:CGFloat = 0
    @State @MainActor var presentType:PresentType? = nil
    @State @MainActor private var scrollType:ScrollType? = .profile
    @State @MainActor private var scrollHeight:CGFloat = 0
    @State @MainActor private var heights:[CGFloat] = [0,0]
    @State @MainActor private var gridType:GridType = .def
    @State @MainActor private var profileOffset:CGFloat = 200
    @State @MainActor private var isTabArea:Bool = false
    //    let publisher: PassthroughSubject<ScrollType, Never> = PassthroughSubject()
    var body: some View{
        NavigationStack {
            ScrollViewReader { scrollProxy in
                ScrollView{
                    scrollObservingView
                    AccountProfile(presentType: $presentType)
                        .id(ScrollType.profile)
                        .environmentObject(vm)
                        .background(GeometryReader{ profileHeight(proxy: $0) })
                    SectionTabView(selectedIdx: $selectedIdx, scrollHeight: $scrollHeight,data: ["Pin","Boards"]){ items in
                        ForEach(items.indices,id:\.self){ idx in
                            if items[idx] == "Boards"{
                                BoardListView().tag(idx).environmentObject(vm)
                            }else{
                                AllPinView(gridType: $gridType).tag(idx)
                            }
                        }.background(GeometryReader { makeHeight(proxy: $0) })
                    }headerView:{ selectedIdx,items in
                        AccountTopHeader(selected: selectedIdx,presentType: $presentType,gridType: $gridType, scrollType: $scrollType,isTabArea: $isTabArea, tabbarItems: items)
                            .padding(.top,4)
                            .environmentObject(vm)
                            .background(.background)
                            .id(ScrollType.store)
                    }
                }
                .clipped()
                .onChange(of: scrollType, perform: { value in
                    guard let value else {return}
                    withAnimation { scrollProxy.scrollTo(value, anchor: .top) }
                    scrollType = nil
                })
                .scrollIndicators(.hidden)
                .toolbar(.hidden, for: .navigationBar)
                .onPreferenceChange(ScrollOffsetKey.self){ offset in
                    if offset + profileOffset < 40{
                        if !isTabArea{ withAnimation(.easeInOut(duration: 0.2)) {isTabArea = true } }
                    }else{
                        if isTabArea{ withAnimation(.easeInOut(duration: 0.2)) { isTabArea = false} }
                    }
                }
                .coordinateSpace(name:"SCROLL")
            }
            .navigationDestination(for: Board.self, destination: { board in
                BoardView(board:board)
            })
        }
        .onChange(of: selectedIdx, perform: { _ in
            scrollType = .store
        })
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
extension ProfileView{
    func profileHeight(proxy: GeometryProxy) -> some View{
        Color.clear.onAppear(){
            profileOffset = proxy.frame(in: .local).height
        }
    }
    func makeHeight(proxy: GeometryProxy) -> some View{
        Color.clear
            .onAppear(){
                if heights[selectedIdx] == 0{
                    heights[selectedIdx] = max(800,proxy.frame(in: .local).height)
                    self.scrollHeight = heights[selectedIdx]
                }
            }
            .onChange(of: selectedIdx,perform:{ newValue in
                Task{@MainActor in
                    try await Task.sleep(for: .seconds(0.2))
                    if heights[selectedIdx] == 0{ heights[selectedIdx] = max(800,proxy.frame(in: .local).height) }
                    withAnimation(.easeInOut(duration: 0.4)) { self.scrollHeight = heights[selectedIdx] }
                }
            })
            .onChange(of: gridType, perform:{ grid in
                Task{@MainActor in
                    try await Task.sleep(for: .seconds(0.1))
                    heights[selectedIdx] = max(800,proxy.frame(in: .local).height)
                    withAnimation(.easeInOut(duration: 0.4)) { self.scrollHeight = heights[selectedIdx] }
                }
            })
    }
    var scrollObservingView: some View{
        GeometryReader { proxy in
            let offsetY = proxy.frame(in: .named("SCROLL")).origin.y
            Color.clear
                .preference(
                    key: ScrollOffsetKey.self,
                    value: offsetY
                )
        }
        .frame(height: 0)
    }
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
struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}
