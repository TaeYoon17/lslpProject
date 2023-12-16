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
    let content : (PhotoImageBridger.ImageState)-> any View
    
    @State var imageState:PhotoImageBridger.ImageState = .empty
    @Binding var isPresented:Bool
    @State private var prevImage: UIImage? = nil
    @State private var showCropView = false
    @State private var selectedImage: UIImage? = nil
    @State private var croppedImage: UIImage? = nil
    @State private var imageSelection: PhotosPickerItem?
    
    let size = CGSize(width: 360, height: 360)
    init(isPresented: Binding<Bool>,size:CGSize? = nil,content:@escaping (PhotoImageBridger.ImageState)->any View){
    스유도_라벨링_됨:do{
        self._isPresented = isPresented
        self.content = content
    }
    }
    var body: some View{
        AnyView(content(imageState)).photosPicker(isPresented: $isPresented, selection: $imageSelection,matching: .images)
            .onChange(of: imageSelection, perform: { newValue in
                guard let newValue else {return}
                let progress = newValue.loadTransferable(type: PhotoImageBridger.ImageData.self) {result in
                    Task {@MainActor in
                        guard imageSelection == self.imageSelection else {
                            print("Failed to get the selected item.")
                            return
                        }
                        switch result {
                        case .success(let profileImage?):
                            let uiimage = UIImage.fetchBy(data: profileImage.image,size: size)
                            self.selectedImage = uiimage
                        case .success(nil):
                            imageState = .empty
                        case .failure(let error):
                            imageState = .failure(error)
                        }
                    }
                }
                imageState = .loading(progress)
            })
            .onChange(of: selectedImage, perform: { newValue in
                if let newValue{
                    self.showCropView = true
                }
            })
            .fullScreenCover(isPresented: $showCropView, onDismiss: {
                selectedImage = nil
            }, content: {
                CropView(size: size,image: selectedImage){ croppedImage,status in
                    if !status{
                        self.croppedImage = croppedImage
                    }else{
                        self.imageState = .failure(ImageServiceError.PHAssetFetchError)
                    }
                }
                .onDisappear(){
                    if let croppedImage{
                        self.imageState = .success(croppedImage)
                        prevImage = croppedImage
                    }else{
                        if let prevImage{
                            self.imageState = .success(prevImage)
                        }else{
                            self.imageState = .empty
                        }
                    }
                    croppedImage = nil
                }
                
            })
            .onTapGesture { isPresented.toggle() }
    }
}
