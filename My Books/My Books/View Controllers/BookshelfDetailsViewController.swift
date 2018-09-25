//
//  BookshelfDetailsViewController.swift
//  My Books
//
//  Created by Jason Modisett on 9/25/18.
//  Copyright © 2018 Jason Modisett. All rights reserved.
//

import UIKit

class BookshelfDetailsViewController: UIViewController, UITextFieldDelegate {

    // MARK:- View lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK:- UITextFieldDelegate methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    // MARK:- IBActions
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
