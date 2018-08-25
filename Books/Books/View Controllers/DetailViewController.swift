//
//  DetailViewController.swift
//  Books
//
//  Created by Andrew Liao on 8/21/18.
//  Copyright © 2018 Andrew Liao. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController{
    
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
            let readButtonText = book.haveRead ? "Read" : "Not Read"
            readButton.setTitle(readButtonText, for: .normal)
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
            readButton.setTitle("Not Read", for: .normal)
            readButton.isUserInteractionEnabled = false
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
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    
    @IBAction func add(_ sender: Any) {
        guard let review = reviewTextView.text,
            let book = book else {return}
        let haveRead = readButton.titleLabel?.text == "Read" ? true: false
        
        //when button title is save - update review and hasRead properties
        if addButtonOutlet.title == "Save" {
            bookController?.update(book: book, review: review, haveRead: haveRead)
        } else{
        //when button title is add - create new book locally and tell google api that it has been added to shelf
            
        }
        navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func toggleRead(_ sender: Any) {
        guard let book = book else {return}
        
        bookController?.update(book: book, review: book.review!, haveRead: !book.haveRead)
        
        let readButtonText = book.haveRead ? "Read" : "Not Read"
        readButton.setTitle(readButtonText, for: .normal)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SelectShelf"{
            let destinationVC = segue.destination as! SelectShelfTableViewController
            destinationVC.bookController = bookController
        }
    }
    
    //MARK: - Properties
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var readButton: UIButton!
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
