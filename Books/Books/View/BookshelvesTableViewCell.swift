//
//  BookshelvesTableViewCell.swift
//  Books
//
//  Created by Andrew Liao on 8/21/18.
//  Copyright © 2018 Andrew Liao. All rights reserved.
//

import UIKit

class BookshelvesTableViewCell: UITableViewCell {

    func updateView(){
        guard let book = book else {return}
        titleLabel.text = book.title!
        isReadLabel.text = book.haveRead ? "Read" : "Not Read"
    }
    
    
    //MARK: - Properties
    @IBOutlet weak var isReadLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    var book: Book?{
        didSet{
            updateView()
        }
    }
}
