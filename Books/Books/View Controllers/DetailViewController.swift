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
            
            //means we come from the BookshelvesVC
            guard let imagePath = book.imagePath,
                let imageURL = URL(string: imagePath) else {return}
            
            self.title = book.title!
            authorLabel.text = book.author ?? "N/A"
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
        if let bookRepresentation = bookRepresentation {
            self.title = bookRepresentation.volumeInfo?.title
            authorLabel.text = bookRepresentation.volumeInfo?.authors?.first
            readLabel.text = "Not Read"
            reviewTextView.text = ""
            
            addButtonOutlet.title = "Add"
            
            guard let imageLinks = bookRepresentation.volumeInfo?.imageLinks?.values,
                let imagePath = Array(imageLinks).last,
                let imageURL = URL(string: imagePath) else {return}
            do{
                let image = UIImage(data: try Data(contentsOf: imageURL))
                imageView.image = image
            } catch {
                NSLog("Error loading image")
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
    var bookRepresentation: BookRepresentation?{
        didSet{
            updateView()
        }
    }
}
