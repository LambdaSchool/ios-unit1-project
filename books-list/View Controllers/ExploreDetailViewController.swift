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
    
    var book: BookRepresentation? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pagesTextView: UITextView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var addToCollectionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    

    // MARK: - Methods
    
    @IBAction func addToCollection(_ sender: Any) {
        
    }
    
    private func updateViews() {
        titleLabel?.text = book?.volumeInfo.title
        authorLabel?.text = book?.volumeInfo.authors?.joined(separator: ", ")
        descriptionTextView?.text = book?.volumeInfo.abstract
        if let pageCount = book?.volumeInfo.pageCount {
            pagesTextView?.text = String(pageCount)
        }
        
        addToCollectionButton?.layer.cornerRadius = 10
        addToCollectionButton?.clipsToBounds = true
    }
}
