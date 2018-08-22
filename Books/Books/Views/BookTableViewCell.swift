//
//  BookTableViewCell.swift
//  Books
//
//  Created by Linh Bouniol on 8/21/18.
//  Copyright © 2018 Linh Bouniol. All rights reserved.
//

import UIKit

protocol BookTableViewCellDelegate: class {
    func moreInfoButtonWasTapped(for cell: BookTableViewCell)
}

class BookTableViewCell: UITableViewCell {
    
    var book: Book? {
        didSet {
            updateViews()
        }
    }
    
    weak var delegate: BookTableViewCellDelegate?

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var bookCoverView: UIImageView!
    @IBOutlet weak var moreInfoButton: UIButton!
    
    @IBAction func showMoreInfo(_ sender: Any) {
        delegate?.moreInfoButtonWasTapped(for: self)
        
        updateViews()
    }
    
    
    func updateViews() {
        guard let book = book else { return }
        
        titleLabel.text = book.title
        authorLabel.text = book.authorsString
        
        guard let urlString = book.imageURL else { return }
        guard let url = URL(string: urlString) else { return }
        ImageController.loadImage(at: url) { (image, _) in
            self.bookCoverView.image = image
        }
    }
    
}
