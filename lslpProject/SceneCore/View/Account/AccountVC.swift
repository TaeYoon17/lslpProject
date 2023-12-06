//
//  AccountVC.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/20.
//

import UIKit
import SnapKit
import SwiftUI
final class AccountVC: UIHostingController<AccountView>{
    init() {
        super.init(rootView: AccountView())
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

struct AccountView: View{
    @State private var selectedIdx = 0
    @Namespace var tabbarShow
    @State private var height:CGFloat = 0
    var body: some View{
        NavigationStack {
            GeometryReader{ geometry in
                let globalH = geometry.frame(in: .global).height
                ScrollView{
                    AccountProfile()
                    SectionTabView(selectedIdx: $selectedIdx, data: ["Pin","Boards"], height: globalH){ items in
                        ForEach(items.indices,id:\.self){ idx in
                            Text("Hello world\(idx)").tag(idx)
                        }
                    }headerView:{ selectedIdx,items in
                        AccountTopHeader(selected: selectedIdx, tabbarItems: items,size: 48)
                        .padding(.vertical,4)
                    }
                    .clipped()
                }
                .toolbar(.hidden, for: .navigationBar)
            }.onChange(of: selectedIdx, perform: { value in
                print(value)
            })
        }
    }
}

#Preview {
    AccountView()
}
