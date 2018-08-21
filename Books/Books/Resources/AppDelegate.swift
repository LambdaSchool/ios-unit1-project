//
//  AppDelegate.swift
//  Books
//
//  Created by Andrew Liao on 8/21/18.
//  Copyright © 2018 Andrew Liao. All rights reserved.
//

import UIKit
import GTMAppAuth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return GoogleBooksAuthorizationClient.shared.resumeAuthorizationFlow(with: url)
    }

}

