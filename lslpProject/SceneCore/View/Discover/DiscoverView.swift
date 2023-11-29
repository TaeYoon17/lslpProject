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
    @StateObject var vm = DiscoverVM()
    @State private var selectedIdx = 0
    var body: some View{
        VStack(spacing:0){
            DiscoverTabbar(tabbarItems: vm.boardItems.map{$0.name}
                       ,selected: $selectedIdx)
            TabView(selection:$selectedIdx) {
                ForEach(vm.boardItems.indices,id:\.self){ idx in
                    BoardSectionView(board: vm.boardItems[idx])
                        .environmentObject(vm)
                }
            }.tabViewStyle(.page(indexDisplayMode: .never)).ignoresSafeArea()
        }

    }
}
#Preview {
    DiscoverView()
}



final class DiscoverVC: UIHostingController<DiscoverView>{
    init() {
        super.init(rootView: DiscoverView())
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("Don't use storyboard")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
}
