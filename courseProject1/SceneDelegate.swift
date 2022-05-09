//
//  SceneDelegate.swift
//  courseProject1
//
//  Created by Serhii Kopytchuk on 18.02.2022./Users/
//

import UIKit
import RealmSwift
import LocalAuthentication

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let realm = try! Realm()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
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
        if let _ = self.realm.objects(User.self).filter("current == true").first{
            let context = LAContext()
            var error:NSError? = nil
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
                let reason = "Authorize with face id!"
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] succes, error in
                    DispatchQueue.main.async {
                        guard succes, error == nil else{
                            //failed
                            
                            let realm = try! Realm()
                            let users = realm.objects(User.self)
                            realm.beginWrite()
                            for user in users{
                                user.current = false
                            }
                            try! realm.commitWrite()
                            
                            let rootViewController = self?.window!.rootViewController as! UINavigationController
                                let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                let profileViewController = mainStoryboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                            rootViewController.pushViewController(profileViewController, animated: true)
                            
                            return
                        }
                        let user = self?.realm.objects(User.self).filter("current == true").first
                        self?.realm.beginWrite()
                        user?.isAutorized = true
                        try! self?.realm.commitWrite()
                        
                    }
                }
            }else{
                
            }
        }
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

