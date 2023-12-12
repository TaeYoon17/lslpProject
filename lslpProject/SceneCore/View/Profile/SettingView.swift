//
//  SettingView.swift
//  lslpProject
//
//  Created by 김태윤 on 12/7/23.
//

import SwiftUI

struct SettingView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack {
            List{
                Section {
                    NavItem("Add account") {
                        Image(systemName: "chevron.right")
                    }.wrapLink(value: "add account")
                    NavItem("Notifications",accessory: {
                        Image(systemName: "chevron.right")
                    }).wrapLink(value: "wow")
                    Button{
                        App.Manager.shared.userAccount.onNext(false)
                        self.dismiss()
                    }label:{
                        NavItem("Log out")
                    }
                } header: {
                    Text("Login").foregroundStyle(.text)
                }.tint(.text)
                Section {
                    NavItem("Get help") {
                        Image(systemName: "arrow.up.right")
                    }.wrapLink(value: "gogogo")
                    NavItem("See terms of service") {
                        Image(systemName: "arrow.up.right")
                    }.wrapLink(value: "tos")
                    NavItem("See privacy policy") {
                        Image(systemName: "arrow.up.right")
                    }.wrapLink(value: "tos")
                } header: {
                    Text("Support")
                }
                
            }
            .listStyle(.plain)
            .navigationDestination(for: String.self) { val in
                Text("Hello world").tint(.black)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Image(systemName: "xmark")
                        .wrapBtn {
                            dismiss()
                        }
                }
            })
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingView()
}
