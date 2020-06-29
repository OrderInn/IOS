//
//  AppDelegate.swift
//  OrderInn
//
//  Created by Ivars Ruģelis on 26/03/2020.
//  Copyright © 2020 Ivars Ruģelis. All rights reserved.
//

import UIKit
import OrderInnAPIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        var initFinished = false
        let initCondition = NSCondition()

        let bundle = Bundle(for: AppDelegate.self)
        let version = bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let build = bundle.object(forInfoDictionaryKey: "CFBundleVersion") as! String
        let configuration = ClientConfiguration(environment: .staging,
                                                clientId: "yg6183qd99sim2rybcuqekqdwc1v3agf",
                                                clientString: "OrderInn.iOS/v\(version)-\(build)",
                                                tokenStorage: .keychain,
                                                serverConnection: .http)
        Client.configure(configuration: configuration, completion: { error in
            log("Token minted or loaded with error: %@", String(describing: error))
            initFinished = true
            initCondition.signal()
        })
        if !initFinished {
            initCondition.wait()
        }

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

