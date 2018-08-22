//
//  BookListTabBarViewController.swift
//  books-list
//
//  Created by De MicheliStefano on 21.08.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

protocol CollectionControllerProtocol {
    var collectionController: CollectionController? { get set }
}

protocol BookControllerProtocol {
    var bookController: BookController? { get set }
}

class BookListTabBarViewController: UITabBarController {
    
    // MARK: - Properties
    
    let collectionController = CollectionController()
    
    // MARK: - Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        handleGoogleAuthorization()
        passControllersToChildren()
        collectionController.fetchFromGoogleBooks { (error) in
            if let error = error {
                NSLog("Error fetching collections from Google API: \(error)")
            }
        }
    }

    // Problem: child views are navigation controllers --> how to pass it through to tableviewcontrollers?
    func passControllersToChildren() {
        guard let viewControllers = viewControllers else { return }

        for navController in viewControllers {
            for vc in navController.children {
                if var vc = vc as? CollectionControllerProtocol {
                    vc.collectionController = collectionController
                }
            }
        }
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
