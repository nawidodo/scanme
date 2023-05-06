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
        makeRootController()
        FirebaseApp.configure()

        return true
    }

    private func makeRootController() {
        window = UIWindow(frame: UIScreen.main.bounds)

        let rootNC: UINavigationController = .init(rootViewController: ScanConfigurator().configure())

        window?.rootViewController = rootNC
        window?.makeKeyAndVisible()
        
        guard let frame = window?
            .windowScene?
            .statusBarManager?
            .statusBarFrame else { return }

        let statusBar: UIView = .init(frame: frame)
        statusBar.backgroundColor = App.color
        window?.rootViewController?.view.addSubview(statusBar)
    }
}

