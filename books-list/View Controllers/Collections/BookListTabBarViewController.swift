//
//  BookListTabBarViewController.swift
//  books-list
//
//  Created by De MicheliStefano on 21.08.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class BookListTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        handleGoogleAuthorization()
    }
    
    func handleGoogleAuthorization() {
        GoogleBooksAuthorizationClient.shared.authorizeIfNeeded(presenter: self) { (error) in
            if let error = error {
                NSLog("Authorization failed: \(error)")
                return
            }
            NSLog("Google authorization successful")
        }
    }

}
