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
        let rootVC = ScanViewController()
        let interactor = ScanInteractor()
        let presenter = ScanPresenter()
        interactor.presenter = presenter
        interactor.ocrService = OCRService()
        interactor.fileService = FileService()
        interactor.cloudService = FirebaseService()
        presenter.view = rootVC
        rootVC.interactor = interactor
        let rootNC = UINavigationController(rootViewController: rootVC)
        window?.rootViewController = rootNC
        window?.makeKeyAndVisible()
        FirebaseApp.configure()
        
        return true
    }
}

