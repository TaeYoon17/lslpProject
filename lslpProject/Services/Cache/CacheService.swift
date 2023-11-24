//
//  CacheService.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/23.
//
import Foundation
import UIKit
final class CacheService{
    static let shared = CacheService()
    let cacheTable = App.CacheType.allCases.reduce(into: [:]) {
        $0[$1] = NSCache<NSString,UIImage>()
    }
    private init(){}
    func resetCache(type: App.CacheType){
        cacheTable[type]?.removeAllObjects()
    }
}
