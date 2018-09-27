//
//  LibraryNavigationController.swift
//  Books
//
//  Created by Farhan on 9/27/18.
//  Copyright © 2018 Farhan. All rights reserved.
//

import UIKit

class LibraryNavigationController: UINavigationController {
    
    var bookController = BookController()

    override func viewDidLoad() {
        super.viewDidLoad()

        for childVC in children {
            if let childVC = childVC as? LibraryCollectionViewController {
                childVC.bookController = bookController
            }
        }
        
    }

}
