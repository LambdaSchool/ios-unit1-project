//
//  BookTabBarViewController.swift
//  Books
//
//  Created by Andrew Liao on 8/24/18.
//  Copyright © 2018 Andrew Liao. All rights reserved.
//

import UIKit

class BookTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passControllerToChildVC()
    }
    
    func passControllerToChildVC(){
        guard let navigationVCs = viewControllers else {return}
        for navigationVC in navigationVCs {
            let childVCs = navigationVC.childViewControllers
            for childVC in childVCs{
                if let vc = childVC as? BookControllerProtocol{
                    vc.bookController = bookController
                }
            }
        }
        
    }
    
    let bookController = BookController()
}
