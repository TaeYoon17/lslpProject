//
//  BoardView.swift
//  lslpProject
//
//  Created by 김태윤 on 12/22/23.
//

import SwiftUI
import RxSwift
struct BoardView: View {
    @Environment(\.dismiss) var dismiss
    var board: Board
    let images = ["ARKit","AsyncSwift","Collections","lgWin","rabbits","macOS","Metal"]
    enum SheetType:Identifiable{
        var id:String{UUID().uuidString}
        case edit
        case filter
    }
    @State private var gridType: GridType = .def
    @State private var filterPresent = false
    @State private var sheetType:SheetType? = nil
    var body: some View {
        ScrollView{
            VStack{
                header
                pins
                Color.clear.frame(height: 66)
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar(.hidden, for: .tabBar)
        .toolbar{
            ToolbarItem(placement: .topBarLeading) {
                Image(systemName: "chevron.left").fontWeight(.semibold).wrapBtn { dismiss() }
            }
            ToolbarItemGroup(placement: .topBarTrailing) {
                Image(systemName: "slider.horizontal.3").fontWeight(.semibold).wrapBtn {
                    sheetType = .filter
                }
            }
        }
        .sheet(item: $sheetType, content: { item in
            switch item{
            case .edit:
                BoardEditView().any()
            case .filter:
                ViewOptionView {
                    Group{
                        ViewOptionSection(header: "Board options") {
                            ViewOptionItem(isSelected: false, name: "Board Edit") {
                                sheetType = .edit
                            }
                        }
                        ViewOptionSection(header: GridType.header) {
                            GridType.OptionView(selectedGrid: $gridType)
                        }
                    }
                }.any()
            }
        })
        
        .overlay(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            Button(action: {
                print("appendItem")
            }, label: {
                Image(systemName: "plus").font(.title2.bold())
                    .padding(.all)
                    .foregroundStyle(.text)
                    .background(.regularMaterial)
                    .clipShape(Circle())
                    .shadow(radius: 1)
            })
        }
        .onAppear(){ App.Manager.shared.hideTabbar.onNext(true) }
    }
}
// MARK: -- Pin
extension BoardView{
    var pins: some View{
        Section {
            VStack{
                StaggredGrid(columns: GridType.def.gridColumns, list: images) { image in
                    NavigationLink {
                        LazyView(PinView(image: image))
                    } label: {
                        Image(image).resizable()
                            .aspectRatio(contentMode: .fit)
                            .background(.orange)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                }
                Spacer()
            }
        } header: {
            HStack{
                Text("\(images.count) 핀").font(.title3).bold()
                Spacer()
            }
        }.padding(.horizontal)
    }
}

//MARK: -- 해더
extension BoardView{
    var header: some View{
        VStack(alignment:.center,spacing: 16){
            Text(board.name).font(.largeTitle.bold())
            HStack(alignment:.center,spacing:16){
                headerButton(text: "More Ideas", icon: "wand.and.stars.inverse") {
                    LazyView(ArrangeView())
                }
                headerButton(text: "Organize", icon: "square.filled.on.square") {
//                    ArrangeView()
                    LazyView(ArrangeView())
                }
            }
        }
    }
    func headerButton(text:String,icon:String,action:@escaping ()-> some View) -> some View{
        NavigationLink {
            action()
        } label: {
            VStack(alignment:.center){
                RoundedRectangle(cornerRadius: 16).fill(.regularMaterial)
                    .frame(width: 88, height: 88, alignment: .center)
                    .overlay(alignment: .center) {
                        Image(systemName:icon )
                            .font(.title2)
                            .bold()
                    }
                Text(text).font(.subheadline)
            }
        }.tint(.text)
    }
}
