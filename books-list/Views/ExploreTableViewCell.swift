//
//  ExploreTableViewCell.swift
//  books-list
//
//  Created by De MicheliStefano on 21.08.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class ExploreTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    var book: BookRepresentation? {
        didSet {
            updateViews()
        }
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var bookImageView: UIImageView!
    
    // MARK: - Methods
    private func updateViews() {
        titleLabel?.text = book?.volumeInfo.title
        authorLabel?.text = book?.volumeInfo.authors?.joined(separator: ", ")
        
        
    }

}
