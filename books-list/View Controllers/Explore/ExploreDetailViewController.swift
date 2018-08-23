//
//  ExploreDetailViewController.swift
//  books-list
//
//  Created by De MicheliStefano on 21.08.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class ExploreDetailViewController: UIViewController {

    // MARK: - Properties
    
    var bookRepresentation: BookRepresentation?
    var collectionController: CollectionController?
    var bookController: BookController?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pagesTextView: UITextView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var addToCollectionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabels()
        formatButton()
        fetchAndSetImage()
    }
    

    // MARK: - Methods
    
    @IBAction func addToCollection(_ sender: Any) {
        
    }
    
    private func updateLabels() {
        titleLabel?.text = bookRepresentation?.volumeInfo.title
        authorLabel?.text = bookRepresentation?.volumeInfo.authors?.joined(separator: ", ")
        descriptionTextView?.text = bookRepresentation?.volumeInfo.abstract
        if let pageCount = bookRepresentation?.volumeInfo.pageCount {
            pagesTextView?.text = String(pageCount)
        }
    }
    
    private func fetchAndSetImage() {
        if let bookRepresentation = bookRepresentation {
            bookController?.fetchImageDataFromGoogleBooks(withURL: bookRepresentation.volumeInfo.imageLinks.thumbnail) { (data, error) in
                if let error = error {
                    NSLog("Error fetching image data: \(error)"); return }
                guard let data = data else { NSLog("Could not load image data"); return }
                
                DispatchQueue.main.async {
                    self.bookRepresentation?.image = data
                    self.imageView?.image = UIImage(data: data)
                }
            }
        }
    }
    
    private func formatButton() {
        addToCollectionButton?.layer.cornerRadius = 10
        addToCollectionButton?.clipsToBounds = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddToCollectionsModal" {
            let addToCollectionsVC = segue.destination as! AddToCollectionsTableViewController
            // When the user intends to add the book to a collection, we create a new Book instance and pass it down
            if let bookRepresentation = bookRepresentation {
                addToCollectionsVC.book = bookController?.create(bookRepresentation)
            }
            addToCollectionsVC.collectionController = collectionController
        }
    }
    
}
