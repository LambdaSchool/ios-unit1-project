//
//  BookCollectionViewCell.swift
//  Books
//
//  Created by Linh Bouniol on 8/23/18.
//  Copyright © 2018 Linh Bouniol. All rights reserved.
//

import UIKit

protocol BookCollectionViewCellDelegate: class {
    func moreInfoButtonWasTapped(for cell: BookCollectionViewCell)
}

class BookCollectionViewCell: UICollectionViewCell {
    
    var book: Book? {
        didSet {
            updateViews()
        }
    }
    
    weak var delegate: BookCollectionViewCellDelegate?
    
    @IBOutlet weak var bookCoverView: UIImageView!
    @IBOutlet weak var moreInfoButton: UIButton!
    
    @IBAction func showMoreInfo(_ sender: Any) {
        delegate?.moreInfoButtonWasTapped(for: self)
        
        updateViews()
    }
    
    
    func updateViews() {
        guard let book = book else { return }
        
        guard let urlString = book.imageURL else { return }
        guard let url = URL(string: urlString) else { return }
        ImageController.loadImage(at: url) { (image, _) in
            self.bookCoverView.image = image
        }
    }
}
