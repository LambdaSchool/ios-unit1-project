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
        guard let volumeRepresentation = volumeRepresentation else { return }
        let authorsText = volumeRepresentation.volumeInfo.authors.joined(separator: ", ")
        let thumbnail = volumeRepresentation.volumeInfo.imageLinks.thumbnail
        
        bookTitleLabel.text = volumeRepresentation.volumeInfo.title
        authorsLabel.text = "by \(authorsText)"
        
        let url = URL(string: thumbnail)
        
        do {
            let data = try Data(contentsOf: url!)
            DispatchQueue.main.async {
                self.bookImageView.image = UIImage(data: data)
            }
        } catch {
            NSLog("Error creating image data from url: \(error)")
        }
        
    }
    
    // MARK: - Action Method
    
    @IBAction func addBookToBookshelf(_ sender: Any) {
    }
    
    // MARK: - Properties
    
    var volumeRepresentation: VolumeRepresentation? {
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
