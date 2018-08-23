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
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    
    func updateView(){
        guard isViewLoaded else {return}
        if let book = book {
            
            print(book.author, book.imagePath)
            //means we come from the BookshelvesVC
            guard let imagePath = book.imagePath,
                let imageURL = URL(string: imagePath) else {return}
            
            self.title = book.title!
            if let author = book.author{
            authorLabel.text = author
            } else {
                authorLabel.text = "N/A"
            }
            readLabel.text = book.haveRead ? "Read" : "Not Read"
            
            reviewTextView.text = book.review!
            addButtonOutlet.title = "Save"
            
            do{
                let data = try Data(contentsOf: imageURL)
                imageView.image = UIImage(data: data)
            } catch {
                NSLog("Error getting image: \(error)")
            }


        }
    }
    
    @IBAction func add(_ sender: Any) {
        
    }
    
    
    //MARK: - Properties
    @IBOutlet weak var authorLabel: UILabel!
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
