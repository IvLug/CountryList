//
//  AppDelegate.swift
//  CountryListDemo
//
//  Created by Ivan Lugantsov on 04.05.2022.
//

import UIKit
import CoreData

let log = Logger()

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.overrideUserInterfaceStyle = .light
        let vc = TabBarController() //RegionListAssembly.assembly().view
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        return true
    }
}

