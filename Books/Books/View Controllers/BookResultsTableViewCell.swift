//
//  BookResultsTableViewCell.swift
//  Books
//
//  Created by Daniela Parra on 9/25/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import UIKit

class BookResultsTableViewCell: UITableViewCell {

    private func updateViews() {
        guard let volume = volume else { return }
        
        bookTitleLabel.text = volume.title
        authorsLabel.text = "by \(volume.authors)"
        displayImage(volume: volume)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    
    //Doesn't work yet.
    private func displayImage(volume: Volume) {
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
