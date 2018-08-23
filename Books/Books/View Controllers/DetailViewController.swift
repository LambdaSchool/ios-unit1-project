//
//  DetailViewController.swift
//  Books
//
//  Created by Andrew Liao on 8/21/18.
//  Copyright © 2018 Andrew Liao. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    //MARK: - Methods
    func updateView(){
        if let book = book {
            //means we come from the BookshelvesVC
            //            if let imagePath = book.imagePath{
            //                imageView.image = UIImage(named: imagePath)
            //            }
            self.title = book.title!
            let tf = book.haveRead
            if tf{
                readLabel?.text =  "Read"
            } else {
                readLabel?.text =  "Not Read"
            }
            
            reviewTextView?.text = book.review!
            addButtonOutlet?.title = "Save"
        }
    }
    
    @IBAction func add(_ sender: Any) {
        
    }
    
    
    //MARK: - Properties
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var readLabel: UILabel!
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var addButtonOutlet: UIBarButtonItem!
    
    var bookController: BookController?
    var book: Book? {
        didSet{
            updateView()
        }
    }
}
