//
//  AppDelegate.swift
//  vezdecod-pincode
//
//  Created by Александр on 24.04.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let mainVC = MainViewController.init(nibName: nil, bundle: nil)
        let navigationController = UINavigationController.init(rootViewController: mainVC)
        self.window?.rootViewController = navigationController
        
        return true
    }

}

