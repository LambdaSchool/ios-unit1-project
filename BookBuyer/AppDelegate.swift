//
//  AppDelegate.swift
//  BookBuyer
//
//  Created by William Bundy on 8/21/18.
//  Copyright © 2018 William Bundy. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?


	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
	{
		return true
	}

	func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
		return GBooksAuthClient.shared.resumeAuthorizationFlow(with: url)
	}


}

