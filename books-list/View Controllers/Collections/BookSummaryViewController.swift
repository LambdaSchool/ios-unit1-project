//
//  BookSummaryViewController.swift
//  books-list
//
//  Created by De MicheliStefano on 21.08.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit
import NotificationCenter

class BookSummaryViewController: UIViewController {

    
    // MARK: - Properties
    var bookController: BookController?
    var collectionController: CollectionController?
    var book: Book? {
        didSet {
            updateViews()
        }
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var buttonLabel: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var noteTextField: UITextField!
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        
        updateViews()
    }
    
    @IBAction func addNote(_ sender: Any) {
        guard let noteText = noteTextField?.text,
            let book = book,
            let note = bookController?.createNote(with: noteText) else { return }
        
        bookController?.add(note, to: book)
        
        noteTextField.text?.removeAll()
        view.endEditing(true)
        
        // Send a notification to the notes table view to update its view
        NotificationCenter.default.post(name: Notification.Name("AddedPost"), object: nil)
        
    }
    
    
    @IBAction func markAsFinished(_ sender: Any) {
        if let book = book {
            bookController?.markAsRead(for: book)
        }
        updateViews()
    }
    
    private func updateViews() {
        titleLabel?.text = book?.title
        authorLabel?.text = book?.authors
        if let image = book?.image {
            imageView?.image = UIImage(data: image)
        }
        buttonLabel?.setTitle(book?.hasRead == false ? "Mark as finished" : "Finished", for: .normal)
        buttonLabel?.backgroundColor = book?.hasRead == false ? UIColor.gray : UIColor(red:0.00, green:0.5, blue:0.00, alpha:1.0)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UpdateCollectionsModal" {
            let vc = segue.destination as! AddToCollectionsTableViewController
            vc.book = book
            vc.collectionController = collectionController
        } else if segue.identifier == "EmbedNotesTable" {
            let vc = segue.destination as! NotesTableViewController
            vc.book = book
            vc.bookController = bookController
        }
    }

}
