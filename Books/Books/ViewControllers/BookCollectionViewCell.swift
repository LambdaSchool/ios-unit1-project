//
//  BookCollectionViewCell.swift
//  Books
//
//  Created by Farhan on 9/24/18.
//  Copyright © 2018 Farhan. All rights reserved.
//

import UIKit

class BookCollectionViewCell: UICollectionViewCell {
    
    var book: Book?{
        didSet{
            updateViews()
        }
    }
    
    func updateViews(){
        guard let title = book?.title else {return}
        titleLabel.text = title
    }
    
    @IBOutlet weak var titleLabel: UILabel!
}
