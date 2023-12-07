//
//  SceneDelegate.swift
//  lslpProject
//
//  Created by 김태윤 on 2023/11/14.
//

import UIKit
import RxSwift
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let disposeBag = DisposeBag()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        UITabBar.appearance().barTintColor = .systemBackground
        UITabBar.appearance().tintColor = .text
//        _ = CameraService.shared
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
//
//        OnboardingVC()
        App.Manager.shared.userAccount.debounce(.milliseconds(100), scheduler: MainScheduler.asyncInstance).bind(with: self) {@MainActor owner, isLogIn in
            guard let view = owner.window?.rootViewController?.view else {return}
            print("발생한다")
            let vc = if isLogIn{
               TabVC()
           }else{
               OnboardingVC()
           }
            let coverView = UIView()
            coverView.backgroundColor = .systemBackground
            vc.view.addSubview(coverView)
            coverView.frame = vc.view.bounds
            owner.window?.rootViewController = vc
            owner.window?.makeKeyAndVisible()
            UIView.animate(withDuration: 0.5) {
                coverView.alpha = 0
            }completion: { _ in
                coverView.removeFromSuperview()
            }
//            UIView.animate(with: view, duration: 0.5) {
//                 
//                owner.window?.rootViewController

//            }
        }.disposed(by: disposeBag)
        window?.rootViewController = TabVC()
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

