//
//  SearchBookTableViewCell.swift
//  Books
//
//  Created by Linh Bouniol on 8/21/18.
//  Copyright © 2018 Linh Bouniol. All rights reserved.
//

import UIKit

protocol SearchBookTableViewCellDelegate: class {
    func saveBook(for cell: SearchBookTableViewCell)
}

class SearchBookTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    var searchResult: SearchResult? {
        didSet {
            updateViews()
        }
    }
    
    weak var delegate: SearchBookTableViewCellDelegate?
    
    // MARK: - Outlets/Actions

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    @IBAction func saveBook(_ sender: Any) {
        delegate?.saveBook(for: self)
        
        updateViews()
    }
    
    // MARK: - Methods
    
    func updateViews() {
        guard let searchResult = searchResult else { return }
        
        titleLabel.text = searchResult.title
        authorLabel.text = searchResult.authors?.joined(separator: ", ")
    }
}
