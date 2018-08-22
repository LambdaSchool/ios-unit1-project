//
//  BookTableViewCell.swift
//  Books
//
//  Created by Linh Bouniol on 8/21/18.
//  Copyright © 2018 Linh Bouniol. All rights reserved.
//

import UIKit

class BookTableViewCell: UITableViewCell {
    
    var book: Book? {
        didSet {
            updateViews()
        }
    }

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    func updateViews() {
        guard let book = book else { return }
        
        titleLabel.text = book.title
    }
    
}
