//
//  SceneDelegate.swift
//  EmpBook
//
//  Created by A118830248 on 10/10/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let windowScene = UIWindowScene(session: session, connectionOptions: connectionOptions)
        self.window = UIWindow(windowScene: windowScene)
        self.window?.rootViewController = getInitialViewController()
        self.window?.makeKeyAndVisible()
    }
    
    func getInitialViewController() -> UIViewController {
        do {
            if try DatabaseManager.shared.isUserLoggedIn() {
                guard let dashboardViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: DashboardViewController.self)) as? DashboardViewController else { return UIViewController() }
                let rootVC = UINavigationController(rootViewController: dashboardViewController)
                return rootVC
            } else {
                guard let loginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: LoginViewController.self)) as? LoginViewController else { return UIViewController() }
                let loginService = LoginService()
                let storage: StorageProtocol = DatabaseManager.shared
                loginViewController.viewModel = LoginViewModel(service: loginService, storage: storage)
                let rootVC = UINavigationController(rootViewController: loginViewController)
                return rootVC
            }
        } catch {
            print(error.localizedDescription)
            return UIViewController()
        }
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

