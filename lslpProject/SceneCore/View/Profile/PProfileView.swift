//
//  PProfileView.swift
//  lslpProject
//
//  Created by 김태윤 on 12/17/23.
//

import SwiftUI
import Combine
struct ViewRectKey: PreferenceKey {
    static var defaultValue: [CGRect] = []
    static func reduce(value: inout [CGRect], nextValue: () -> [CGRect]) {
        value = nextValue()
    }
}
struct PProfileView: View {
    enum ScrollType:Hashable{
        case profile
        case store
    }
    @State private var selectedIdx = 0
    @State private var scrollType:ScrollType = .profile
    private var scroll = PassthroughSubject<ScrollType,Never>()
    @State private var rect: CGRect = .zero
    @State var myheight:CGFloat = 0
    var body: some View{
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 0, pinnedViews:[.sectionHeaders]){
                    Section {
                        Text("ProfileView")
                            .id(ScrollType.profile)
                    }
                    Section {
                        TabView(selection: $selectedIdx,content:  {
//                            BoardView()
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100, maximum: 300)),GridItem(.adaptive(minimum: 100, maximum: 300))], content: {
                                ForEach((0...40),id:\.self) { val in
                                    BoardListItem()
                                }
                            })
                            .background(GeometryReader { proxy in
                                Color.blue.preference(key: ViewRectKey.self,value: [proxy.frame(in: .local)])
                                    .onAppear(){
                                        updateRectangleGeoSize(proxy.frame(in: .local))
                                        print(proxy.frame(in:.local))
                                        withAnimation {
                                            self.myheight = proxy.frame(in: .local).height
                                        }
                                    }
                                    
                            })
                            //                        ScrollView(.horizontal) {
                            //                            LazyHStack{
                            //                                BoardView()
                            //                                    .containerRelativeFrame(.horizontal)
                            //                                Text("Hello world")
                            //                                    .containerRelativeFrame(.horizontal)
                            //                            }
                            //                        }.scrollTargetBehavior(.viewAligned)
                            //                        .scrollTargetLayout()
                        }).tabViewStyle(.page(indexDisplayMode: .never))
                        .frame(height: myheight + 1 /* just to avoid page indicator overlap */)
                            .background(Color.red)
                            .onPreferenceChange(ViewRectKey.self) { rects in
                                print(rects)
                                self.rect = rects.first ?? .zero
                            }
                    } header: {
                        Text("TestHeader").id(ScrollType.store)
                            .onTapGesture {
                                print("TeatHeader Tapped")
                                //                                scrollType = .profile
                                scroll.send(.profile)
                            }
                    }.padding(.horizontal)
                        .frame(maxHeight:.infinity)
                        .background(.red)
                        .frame(maxHeight:.infinity)
                        .onReceive(scroll) { output in
                            withAnimation {
                                proxy.scrollTo(output,anchor: .top)
                            }
                        }
                }
            }
        }
    }
    func updateRectangleGeoSize(_ size: CGRect) -> some View {
        preference(key: ViewRectKey.self, value: [size])
    }
}
#Preview {
    PProfileView()
}
