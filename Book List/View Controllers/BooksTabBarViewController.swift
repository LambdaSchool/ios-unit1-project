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
        passVolumeControllerToChildViewControllers()
    }
    func passVolumeControllerToChildViewControllers() {
        for childVC in children {
            guard let childVC = childVC as? VolumeControllerProtocol else { return }
            childVC.volumeController = volumeController
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let volumeController = VolumeController()

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
