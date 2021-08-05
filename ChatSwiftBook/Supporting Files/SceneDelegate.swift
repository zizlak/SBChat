//
//  SceneDelegate.swift
//  ChatSwiftBook
//
//  Created by Aleksandr Kurdiukov on 17.06.21.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: scene.coordinateSpace.bounds)
        window?.windowScene = scene
        defineVC { vc in self.window?.rootViewController = vc }
        
        window?.makeKeyAndVisible()
    }
    
    
    private func defineVC(complete: @escaping(UIViewController) -> ()) {
        if let user = Auth.auth().currentUser {
            FireStoreService.shared.getUserData(user: user) { result in
                switch result {
                
                case .success(let muser):
                    complete(MainTabBarController(user: muser))
                case .failure(_):
                    complete(AuthVC())
                }
            }
        } else {
            complete(AuthVC())
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {

    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }
}

