//
//  LazyView.swift
//  lslpProject
//
//  Created by 김태윤 on 12/25/23.
//

import SwiftUI

struct LazyView<T: View>:View {
    let view: ()->T
    init(_ view:@autoclosure @escaping ()->T){
        self.view = view
    }
    var body: some View {
        view()
    }
}
