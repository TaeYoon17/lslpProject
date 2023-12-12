//
//  AccountVC.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/20.
//

import UIKit
import SnapKit
import SwiftUI
import Combine
final class ProfileVC: UIHostingController<ProfileView>{
    @DefaultsState(\.navigationBarHeight) var naviHeight
    init() {
        super.init(rootView: ProfileView())
        let nav = UINavigationController(rootViewController: self)
        self.naviHeight = nav.navigationBar.frame.height
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("Don't use storyboard")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewwillappear")
        guard let tabBarController else {return}
        self.tabBarController?.tabBar.isHidden = false
        if let tabbarController = self.tabBarController as? TabVC{
            tabbarController.tabBarDidLoad(vc: self)
        }
        
            
    }
}

struct ProfileView: View{
    enum ScrollType:Hashable{
        case profile
        case store
    }
    let vm = ProfileVM()
    
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
                        case .profile: ProfileEditView()
                        }
                    } fullScreen: { item in
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

#Preview {
    ProfileView()
}

fileprivate extension View{
    func present<A:View,B:View>(presentType:Binding<ProfileView.PresentType?>,sheet:@escaping ((ProfileView.SheetType) -> A),fullScreen:@escaping ((ProfileView.FullscreenType) -> B))->some View{
        self.modifier(ProfileView.SheetModifier(presentType: presentType, sheet: sheet, fullScreen: fullScreen))
    }
}
