//
//  AppDelegate.swift
//  books-list
//
//  Created by De MicheliStefano on 20.08.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GoogleBooksAuthorizationClient.shared.resumeAuthorizationFlow(with: url)
    }

}

