//
//  BookSummaryViewController.swift
//  books-list
//
//  Created by De MicheliStefano on 21.08.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class BookSummaryViewController: UIViewController {

    
    // MARK: - Properties
    var bookController: BookController?
    var collectionController: CollectionController?
    var book: Book?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var buttonLabel: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    @IBAction func markAsFinished(_ sender: Any) {
        
    }
    
    private func updateViews() {
        titleLabel?.text = book?.title
        authorLabel?.text = book?.authors
        if let image = book?.image {
            imageView?.image = UIImage(data: image)
        }
        
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UpdateCollectionsModal" {
            let vc = segue.destination as! AddToCollectionsTableViewController
            vc.book = book
            vc.collectionController = collectionController
        }
    }

}
