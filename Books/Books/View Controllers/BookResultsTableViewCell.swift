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
        displayImage(volume: volume)
        
    }
    
    //Doesn't work yet.
    private func displayImage(volume: Volume) {
        //check that image string exists or works
        //set volumes without image to a default image
        
        let url = URL(string: volume.image!)
        
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
