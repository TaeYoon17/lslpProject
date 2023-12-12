//
//  PinView.swift
//  lslpProject
//
//  Created by 김태윤 on 12/6/23.
//

import Foundation
import SwiftUI
struct PinView: View{
    @EnvironmentObject var discoverVM: DiscoverVM
    @DefaultsState(\.navigationBarHeight) var naviHeight
    let image: String
    var body: some View{
        ScrollView{
            Spacer().frame(height: 1)
            VStack{
                Image(image,bundle: nil)
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.current!.bounds.width)
                PinProfileBanner()
                PinBottom()
            }.padding(.horizontal,16)
                    
            Divider().padding(.vertical,4)
            Section {
                TextField("Add the first comment", text: .constant(""))
                    .textFieldStyle(.roundedBorder)
                    .padding()
            } header: {
                HStack{
                    Text("What do you think?")
                    Spacer()
                    HStack(spacing:4){
                        Image(systemName: "heart")
                        Text("8")
                    }
                }.padding(.horizontal)
                    .font(.headline)
            }
            Divider().padding(.vertical,4)
        }
            .offset(y: -naviHeight)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.visible, for: .navigationBar)
        .toolbarBackground(.hidden, for: .navigationBar)
        
    }
    
    
}

#Preview(body: {
    NavigationStack {
        PinView(image: "Metal").environmentObject(DiscoverVM())
    }
    
})

