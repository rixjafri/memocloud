//
//  SceneDelegate.swift
//  Memo Cloud
//
//  Created by Rizwan Shah on 28/01/2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate, QuickMenuDelegate {

    var window: UIWindow?
    static var sharedInstance: SceneDelegate {
        return  UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
    }
    
    lazy var floatingButton : FloatingView = {
        let normalButton = UIButton()
        normalButton.backgroundColor = .clear
        normalButton.frame = CGRect(x: 0, y: (UIScreen.main.bounds.height / 2) - 20.0, width: 48, height: 48)
        normalButton.layer.cornerRadius = 24
        normalButton.setImage(UIImage(named: "Floatingbutton"), for: .normal)
        normalButton.addTarget(self, action: #selector(openMenu), for: .touchUpInside)
        var floatingView = FloatingView(with: normalButton)
        floatingView.delegate = self
        return floatingView
    }()
    
    @objc func openMenu() {
        
        
        UIView.animate(withDuration: 0.3) {
            self.floatingButton.floatingView.alpha = 1.0
        }
        guard let viewController = UIViewController.topMostViewController() else { return }
        
        DispatchQueue.main.async {
            let tabbarHeight = viewController.tabBarController?.tabBar.bounds.height ?? 0
            let frame = CGRect(x: viewController.view.bounds.origin.x, y: viewController.view.bounds.origin.y, width: viewController.view.bounds.width, height: viewController.view.bounds.height + tabbarHeight)
            QuickMenu.sharedInstance.showPopup(vc: viewController, dalagate: self, parentview: viewController.view, frame: frame)
            
        }
        
        delay(durationInSeconds: 10.0) {
            UIView.animate(withDuration: 0.3) {
                self.floatingButton.floatingView.alpha = 0.4
            }
        }
    }

    func didHidePopup() {
//        guard let viewController = UIViewController.topMostViewController() else { return }
//        viewController.showTabbar()
    }
    


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
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    func pushToLoginRoot(isAnimate: Bool = true) {
        guard let navigationController = window?.rootViewController as? UINavigationController else {
            print("Root view controller is not a navigation controller")
            return
        }
        
        // Check if the current top view controller is already LoginVC
        if navigationController.topViewController is LoginVC {
            print("Already on the login screen")
            return
        }
        
            // Load and push the LoginVC if it's not already on top
            let vc = UIStoryboard.storyBoard(withName: .auth).loadViewController(withIdentifier: .loginVC) as! LoginVC
            navigationController.pushViewController(vc, animated: isAnimate)
        
        
    }
    
    func pushToDashborad(){
        
        
        let vc = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .dashboardVC) as! DashboardVC

        // Ensure the rootViewController is a UINavigationController
        if let navigationController = window?.rootViewController as? UINavigationController {
            navigationController.pushViewController(vc, animated: true)
        } else {
            print("Root view controller is not a navigation controller")
        }
    }
    
    
    
    func pushToUpload(type: Int){
        // 0: text, 1: picture, 2: video
        
        let vc = UIStoryboard.storyBoard(withName: .main).loadViewController(withIdentifier: .uploadVC) as! UploadVC
        vc.type = type
        // Ensure the rootViewController is a UINavigationController
        if let navigationController = window?.rootViewController as? UINavigationController {
            navigationController.pushViewController(vc, animated: true)
        } else {
            print("Root view controller is not a navigation controller")
        }
    }
    
    func pushToPasswordUpdate(){
        
        let vc = UIStoryboard.storyBoard(withName: .auth).loadViewController(withIdentifier: .passwordChangeVC) as! PasswordChangeVC
        
        // Ensure the rootViewController is a UINavigationController
        if let navigationController = window?.rootViewController as? UINavigationController {
            
            navigationController.pushViewController(vc, animated: true)
        } else {
            print("Root view controller is not a navigation controller")
        }
    }


}

extension SceneDelegate:FloatingViewDelegate {
    
    func viewDraggingDidBegin(view: UIView, in window: UIWindow?) {
        UIView.animate(withDuration: 0.3) {
            view.alpha = 1.0
        }
    }
    
    func viewDraggingDidEnd(view: UIView, in window: UIWindow?) {
        (view as? UIButton)?.cancelTracking(with: nil)
        UIView.animate(withDuration: 0.4) {
            view.alpha = 1.0
        }
        
        delay(durationInSeconds: 10.0) {
            UIView.animate(withDuration: 0.3) {
                view.alpha = 0.4
            }
        }
    }
}

