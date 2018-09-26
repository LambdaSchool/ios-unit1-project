//
//  BooksTabBarViewController.swift
//  Book List
//
//  Created by Moin Uddin on 9/25/18.
//  Copyright © 2018 Moin Uddin. All rights reserved.
//

import UIKit

class BooksTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        authorizeGoogleBooks()
        passControllersToChildViewControllers()
    }
    func passControllersToChildViewControllers() {
        for childVC in children {
            if let childVC = childVC as? BookshelfControllerProtocol {
                childVC.bookshelfController = bookshelfController
            }
        }
    }
    func authorizeGoogleBooks() {
        GoogleBooksAuthorizationClient.shared.authorizeIfNeeded(presenter: UIViewController()) { (error) in
            if let error = error {
                NSLog("There was an error authenticating Google Books \(error)")
                return
            }
            print("Google Authenticated")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let volumeController = VolumeController()
    let bookshelfController = BookshelfController()

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
