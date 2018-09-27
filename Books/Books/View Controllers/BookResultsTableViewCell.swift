//
//  BookResultsTableViewCell.swift
//  Books
//
//  Created by Daniela Parra on 9/25/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import UIKit
import Photos

class BookResultsTableViewCell: UITableViewCell {
    
    // MARK: - Private Methods

    private func updateViews() {
        guard let volumeRepresentation = volumeRepresentation else { return }
        let authorsText = volumeRepresentation.volumeInfo.authors.joined(separator: ", ")
        let thumbnailString = volumeRepresentation.volumeInfo.imageLinks.thumbnail
        
        bookTitleLabel.text = volumeRepresentation.volumeInfo.title
        authorsLabel.text = "by \(authorsText)"
        
        //Make image
        let url = URL(string: thumbnailString)!
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                NSLog("Error: \(error)")
            }
            
            guard let data = data else { return }
            
            guard let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self.bookImageView.image = image
            }
        }.resume()
    
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
