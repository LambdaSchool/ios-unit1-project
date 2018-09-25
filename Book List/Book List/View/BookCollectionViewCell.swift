//
//  BookCollectionViewCell.swift
//  Book List
//
//  Created by Dillon McElhinney on 9/24/18.
//  Copyright © 2018 Dillon McElhinney. All rights reserved.
//

import UIKit

class BookCollectionViewCell: UICollectionViewCell {
    
    var book: Book? {
        didSet{
            updateViews()
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bookImageView: UIImageView!
    
    private func updateViews() {
        guard let book = book else { return }
        
        titleLabel.text = book.title
        if let imageData = book.thumbnailData {
            bookImageView.image = UIImage(data: imageData)
            titleLabel.text = nil
        }
    }
    
}
