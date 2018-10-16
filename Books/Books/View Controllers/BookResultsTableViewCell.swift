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
        
        //Adjust volume representation's variables to display in cell.
        let authorsText = volumeRepresentation.volumeInfo.authors.joined(separator: ", ")
        let thumbnailString = volumeRepresentation.volumeInfo.imageLinks.thumbnail
        
        //Display info from volume representation.
        bookTitleLabel.text = volumeRepresentation.volumeInfo.title
        authorsLabel.text = "by \(authorsText)"
        
        //Perform data task for image data from string of url.
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
    
    // MARK: - Properties
    
    var volumeRepresentation: VolumeRepresentation? {
        didSet {
            updateViews()
        }
    }
    var volumeController: VolumeController?
    
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var authorsLabel: UILabel!
    @IBOutlet weak var bookImageView: UIImageView!
    
}
