//
//  AppDelegate.swift
//  Dafabet
//
//  Created by mac on 28.09.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var settings: Settings!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let networkManager = NetworkManager()
        let userDefaultsManager = UserDefaultsManager()
        
        settings = Settings(userDefaultsManager: userDefaultsManager)
        
        let loaderVC = LoaderViewController()
        loaderVC.viewModel = LoaderViewModel(networkManager: networkManager,
                                             userDefaultsManager: userDefaultsManager)
        
        window?.rootViewController = loaderVC
        window?.makeKeyAndVisible()
        
        return true
    }
}
