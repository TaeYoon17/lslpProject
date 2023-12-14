//
//  ProfileEditImageView.swift
//  lslpProject
//
//  Created by 김태윤 on 12/15/23.
//

import SwiftUI
import PhotosUI
import Combine
struct EditImageView:View{
    @StateObject var bridger: PhotoImageBridger
    let content : (PhotoImageBridger.ImageState)-> any View
    init(size:CGSize? = nil,content:@escaping (PhotoImageBridger.ImageState)->any View){
    스유도_라벨링_됨:do{
        _bridger = .init(wrappedValue: PhotoImageBridger(size: size))
        self.content = content
    }
    }
    var body: some View{
        PhotosPicker(selection: $bridger.imageSelection) {
            AnyView(content(bridger.imageState))
        }
    }
}

//struct ProfileImage: View{
//    let imageState: PhotoImageBridger.ImageState
//    var body: some View {
//        
//        switch imageState {
//        case .success(let image):
//            image.resizable()
//        case .loading:
//            ProgressView()
//        case .empty:
//            Image(systemName: "person.fill")
//        case .failure:
//            Image(systemName: "exclamationmark.triangle.fill")
//        }
//        
//    }
//    
//}
struct Wow:View{
    var body: some View{
        VStack{
//            AsyncImage(url: nil) { phase in
//                switch phase{
//                case .empty:
//                    Text("wow world")
//                case .failure( _):
//                    Image(systemName: "asdf")
//                case .success(let image):
//                    image
//                @unknown default:
//                    Text("wow world")
//                }
//            }
            EditImageView{ state in
                switch state{
                case .empty:
                    Text("wow world")
                case .failure( _):
                    Image(systemName: "asdf")
                case .success(let image):
                    Image(uiImage: image)
                case .loading(_):
                    ProgressView()
                @unknown default:
                    Text("wow world")
                }
            }
        }
    }
}
