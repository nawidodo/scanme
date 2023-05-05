//
//  AppDelegate.swift
//  Scan me! calculator
//
//  Created by Nugroho Arief Widodo on 29/04/23.
//

import UIKit
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        window = UIWindow(frame: UIScreen.main.bounds)

        let rootNC = UINavigationController(rootViewController: ScanConfigurator().configure())

        window?.rootViewController = rootNC
        window?.makeKeyAndVisible()
        FirebaseApp.configure()
        
        return true
    }
}

