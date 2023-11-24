//
//  CacheService+CRUD.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/23.
//

import Foundation
import UIKit
//MARK: -- UIImage에 Extension으로 나머지 수정해야한다.[
extension CacheService{
    func appendImage(type: App.CacheType,names:[String],size:CGSize? = nil) async throws{
        await withThrowingTaskGroup(of: Void.self) {[weak self] group in
            for name in names {
                group.addTask{[weak self] in
                    try await self?.appendImage(type: type,name: name, size: size)
                }
            }
        }
    }
    func appendImage(type: App.CacheType,name:String,size:CGSize? = nil) async throws{
        let keyName = if let size{
            "\(name)_\(Int(size.width))_\(Int(size.height))"
        }else { name }
        guard nil == cacheTable[type]?.object(forKey: keyName as NSString) else {
            return
        }
        do{
            let image = switch type{
            case .albumImage: UIImage()
//                try await UIImage.fetchBy(identifier: name, ofSize: size)
            case .documentImage: UIImage()
//                try await UIImage.fetchBy(fileName: name,ofSize: size)
            case .webImage: UIImage()
//                try await UIImage.fetchBy(link: name, ofSize: size)
            }
            cacheTable[type]?.setObject(image, forKey: keyName as NSString)
        }catch{
            throw error
        }
    }
    func appendImage(type: App.CacheType,name:String,maxSize:CGSize) async throws{
        let keyName = "\(name)_max_\(Int(maxSize.width))_\(Int(maxSize.height))"
        let image = switch type{
        case .albumImage: UIImage()
//            try await UIImage.fetchBy(link: name)
        case .documentImage: UIImage()
//            try await UIImage.fetchBy(fileName: name)
        case .webImage: UIImage()
//            await UIImage.fetchBy(identifier: name)
        }
//        guard let image else {throw FetchError.fetch}
        let size = CGSize(original: image.size, max: maxSize)
        guard let img = await image.byPreparingThumbnail(ofSize: size) else { return}
        cacheTable[type]?.setObject(img, forKey: keyName as NSString)
    }
}
extension CacheService{
    @MainActor func imageFetch(type:App.CacheType,name: String, size:CGSize? = nil) async throws -> UIImage?{
        let keyStr = if let size{ "\(name)_\(Int(size.width))_\(Int(size.height))"
        }else { name }
        let image = if let size{
            await cacheTable[type]?.object(forKey: keyStr as NSString)?.byPreparingThumbnail(ofSize: size)
        }else{
            await cacheTable[type]?.object(forKey: keyStr as NSString)?.byPreparingForDisplay()
        }
        if let image{
            return image
        }else{
            try await appendImage(type: type, name: name, size: size)
        }
        try await Task.sleep(nanoseconds: 1000)
        return if let size{
            await cacheTable[type]?.object(forKey: keyStr as NSString)?.byPreparingThumbnail(ofSize: size)
        }else{
            await cacheTable[type]?.object(forKey: keyStr as NSString)?.byPreparingForDisplay()
        }
    }
    
    @MainActor func iamgeFetch(type:App.CacheType,name: String, maxSize:CGSize) async throws -> UIImage?{
        let keyName = "\(name)_max_\(Int(maxSize.width))_\(Int(maxSize.height))"
        if let image = cacheTable[type]?.object(forKey: keyName as NSString){
            return image
        }else{
            try await appendImage(type: type, name: name, maxSize: maxSize)
        }
        do{ try await Task.sleep(nanoseconds: 1000)
        }catch{ print(error)
        }
        return cacheTable[type]?.object(forKey: keyName as NSString)
    }
}
