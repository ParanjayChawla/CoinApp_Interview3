//
//  AppDelegate.swift
//  CoinTestApp2
//
//  Created by Apple on 09/09/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame:UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        let navigationController = UINavigationController(rootViewController: CoinListVC())
        window?.rootViewController = navigationController
        // Override point for customization after application launch.
        return true
    }

}

