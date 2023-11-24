//
//  AuthCredentail.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/24.
//

import Foundation
import Alamofire
struct AuthCredential : AuthenticationCredential {
    @DefaultsState(\.accessToken) var accessToken
    @DefaultsState(\.refreshToken) var refreshToken
    let expiration: Date
    // Require refresh if within 5 minutes of expiration
    var requiresRefresh: Bool { Date(timeIntervalSinceNow: NetworkService.accessExpireSeconds) > expiration }
}
