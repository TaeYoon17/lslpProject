//
//  ArrangeView.swift
//  lslpProject
//
//  Created by 김태윤 on 12/25/23.
//

import SwiftUI

struct ArrangeView:View {
    @Environment(\.dismiss) var dismiss
    @State var items = ["ARKit","AsyncSwift","Collections","lgWin","rabbits","macOS","Metal"]
    @State private var editMode = EditMode.active
    var body: some View {
        List {
            headerSection
            Section{
                ForEach(items.indices,id:\.self){ idx in
                    HStack {
                        Image(items[idx])
                            .resizable()
                            .scaledToFit()
                            .frame(width:66,height:66)
                        Text(items[idx])
                    }
                }.onMove { indexSet, offset in
                    items.move(fromOffsets: indexSet, toOffset: offset)
                }
                .onDelete { indexSet in
                    items.remove(atOffsets: indexSet)
                }
            }
        }
        .listSectionSeparator(.hidden)
        .listStyle(.plain)
        .environment(\.editMode, $editMode)
//        .toolbar {
//            EditButton().tint(.text)
//        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Image(systemName: "chevron.left").fontWeight(.semibold).wrapBtn { dismiss() }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Text("Save").font(.headline).wrapBtn {
                    dismiss()
                }
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear(){
            print("ArragneView Appear")
        }
    }
}
extension ArrangeView{
    var headerSection: some View{
        Section{
            HStack{
                Spacer()
                Text("선택 또는 재정렬").font(.largeTitle.bold())
                Spacer()
            }
        }.listRowSeparator(.hidden, edges: .all)
    }
}
