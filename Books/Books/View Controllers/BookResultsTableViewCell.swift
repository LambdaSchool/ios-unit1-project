//
//  BookResultsTableViewCell.swift
//  Books
//
//  Created by Daniela Parra on 9/25/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import UIKit

class BookResultsTableViewCell: UITableViewCell {
    
    // MARK: - Private Methods

    private func updateViews() {
        guard let volume = volume else { return }
        
        bookTitleLabel.text = volume.title
        authorsLabel.text = "by \(String(describing: volume.authors))"
        
        volumeController?.displayImage(volume: volume, imageView: bookImageView)
        
    }
    
    // MARK: - Action Method
    
    @IBAction func addBookToBookshelf(_ sender: Any) {
    }
    
    // MARK: - Properties
    
    var volume: Volume? {
        didSet {
            updateViews()
        }
    }
    var volumeController: VolumeController?
    var bookshelfController: BookshelfController?
    
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var authorsLabel: UILabel!
    @IBOutlet weak var bookImageView: UIImageView!
    
}
