//
//  SearchTableViewCell.swift
//  Books
//
//  Created by Farhan on 9/24/18.
//  Copyright © 2018 Farhan. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func addToLibrary(_ sender: Any) {
        delegate?.borrowButtonWasPressed(self)
    }
    
    func updateViews(){
        guard let book = book else {return}
        titleLabel.text = book.volumeInfo.title
        
        authorLabel.text = book.volumeInfo.authors?.first ?? " "
    }
    
    // MARK: - Properties
    var book: BookRepresentation?{
        didSet{
            updateViews()
        }
    }
    
    weak var delegate: BorrowButtonDelegate?
    
    @IBOutlet weak var borrowButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
}
