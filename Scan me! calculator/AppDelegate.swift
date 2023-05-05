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

        if #available(iOS 13.0, *) {
            let statusBar = UIView(frame: window?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
            statusBar.backgroundColor = App.color
            window?.rootViewController?.view.addSubview(statusBar)
        } else {
            // fallback code for earlier iOS versions
            let statusBar = UIApplication.shared.value(forKey: "statusBar") as? UIView
            statusBar?.backgroundColor = App.color
        }
        return true
    }
}

