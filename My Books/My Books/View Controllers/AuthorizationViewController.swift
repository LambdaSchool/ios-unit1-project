//
//  AuthorizationViewController.swift
//  My Books
//
//  Created by Jason Modisett on 9/25/18.
//  Copyright © 2018 Jason Modisett. All rights reserved.
//

import UIKit

class AuthorizationViewController: UIViewController {

    // MARK:- View lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        GoogleBooksAuthorizationClient.shared.authorizeIfNeeded(presenter: self) { (error) in
            
            if let error = error {
                NSLog("There was an error during authorization: \(error)")
            }
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "BookshelvesViewController") as! BookshelvesViewController
            
            vc.modalTransitionStyle = .crossDissolve
            self.navigationController?.present(vc, animated: true)
        }
    }
    
}
