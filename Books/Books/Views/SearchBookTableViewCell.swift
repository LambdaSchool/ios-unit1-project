//
//  SearchBookTableViewCell.swift
//  Books
//
//  Created by Linh Bouniol on 8/21/18.
//  Copyright © 2018 Linh Bouniol. All rights reserved.
//

import UIKit
import CoreData

protocol SearchBookTableViewCellDelegate: class {
    func saveBook(for cell: SearchBookTableViewCell)
}

class SearchBookTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    var bookshelf: Bookshelf?
    
    var searchResult: SearchResult? {
        didSet {
            updateViews()
        }
    }
    
    weak var delegate: SearchBookTableViewCellDelegate?
    
    // MARK: - Outlets/Actions

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var bookCoverView: UIImageView!
    
    @IBAction func saveBook(_ sender: Any) {
        delegate?.saveBook(for: self)
        
        updateViews()
    }
    
    // MARK: - Methods
    
    func updateViews() {
        guard let searchResult = searchResult else { return }
        
        titleLabel.text = searchResult.title
        authorLabel.text = searchResult.authors?.joined(separator: ", ")
        
        if let bookshelf = bookshelf {
            addButton.isEnabled = !doesBookExists(withID: searchResult.identifier, in: bookshelf)
        } else {
            addButton.isEnabled = true
        }
        
        guard let urlString = searchResult.image else { return }
        guard let url = URL(string: urlString) else { return }
        ImageController.loadImage(at: url) { (image, _) in
            self.bookCoverView.image = image
        }
    }
    
    func doesBookExists(withID identifier: String, in bookshelf: Bookshelf) -> Bool {
        
        let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@ && bookshelves CONTAINS %@", identifier, bookshelf)
        
        do {
            let book = try CoreDataStack.shared.mainContext.fetch(fetchRequest).first
            return book != nil
        } catch {
        }
        return false
    }
}
