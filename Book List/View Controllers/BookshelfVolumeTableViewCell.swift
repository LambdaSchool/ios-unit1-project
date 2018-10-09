//
//  BookshelfVolumeTableViewCell.swift
//  Book List
//
//  Created by Moin Uddin on 9/26/18.
//  Copyright © 2018 Moin Uddin. All rights reserved.
//

import UIKit

class BookshelfVolumeTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateViews() {
        guard let volume = volume else { return }
        volumeTitleLabel.text = volume.title
        
        guard let imageLink = volume.imageLink else { return }
        let imageUrl = URL(string: imageLink)!

        URLSession.shared.dataTask(with: imageUrl) { (data, _, error) in
            if let error = error {
                NSLog("Error with request to retrieve image: \(error)")
                return
            }
            guard let data = data else {
                NSLog("There is an error with the data")
                return
            }
            DispatchQueue.main.async {
                self.volumeImage.image = UIImage(data: data)
            }
            }.resume()
    }
    
    @IBOutlet weak var volumeImage: UIImageView!
    
    @IBOutlet weak var volumeTitleLabel: UILabel!
    
    var volume: Volume? {
        didSet {
            updateViews()
        }
    }

}
