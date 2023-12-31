//
//  DiscoverView.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/29.
//

import SwiftUI
import UIKit
import RxSwift
struct DiscoverView:View{
    @StateObject var vm:DiscoverVM = .init()
    @State private var selectedIdx = 0
    @State private var topHeight:CGFloat = 0
    var body: some View{
        VStack(spacing:0){
            TopTabbar(tabbarItems: vm.boardItems.map{$0.boardName},selected: $selectedIdx)
            TabView(selection:$selectedIdx) {
                ForEach(vm.boardItems.indices,id:\.self){ idx in
                    ScrollView{
                        StaggredGrid(columns: 2, list: vm.boardItems[idx].pins) { pin in
                            PinListView(pin: pin)
                        }
                        .padding(.top,8)
                    }
                        
                }
            }.tabViewStyle(.page(indexDisplayMode: .never)).ignoresSafeArea()
                .toolbar(.hidden, for: .navigationBar)
        }
        
    }
}
struct PinListView: View{
    //    @EnvironmentObject var vm:DiscoverVM
    var pin:Pin
    @State private var image: Image?
    var columns :Int = 2
    var body: some View{
        NavigationLink {
            PinView(pin: pin, image: $image)
        } label: {
            if let image{
                image.resizable()
                    .aspectRatio(contentMode: .fit)
                    .background(.orange)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }else{
                Image(systemName: "heart")
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }.task {
            guard let firstData = pin.images.first else {return}
            let width = UIScreen.current!.bounds.width / CGFloat(columns)
            let uiimage = UIImage.fetchBy(data: firstData, size: .init(width: width, height: width))
            self.image = Image(uiImage: uiimage)
        }
    }
}
final class DiscoverVC: UIHostingController<DiscoverView>{
    @DefaultsState(\.navigationBarHeight) var naviHeight
    init() {
        super.init(rootView: DiscoverView())
        let nav = UINavigationController(rootViewController: self)
        self.naviHeight = nav.navigationBar.frame.height
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("Don't use storyboard")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let tabBarController else {return}
        self.tabBarController?.tabBar.isHidden = false
        if let tabbarController = self.tabBarController as? TabVC{
            tabbarController.tabBarDidLoad(vc: self)
        }
    }
}
