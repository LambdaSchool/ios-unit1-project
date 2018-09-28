//
//  BookshelfVolumeCollectionViewCell.swift
//  Books
//
//  Created by Daniela Parra on 9/26/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import UIKit

class BookshelfVolumeCollectionViewCell: UICollectionViewCell {
    
    func updateViews() {
        guard let volume = volume else { return }
        
        let thumbnailString = volume.image ?? ""
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
    
    
    var volume: Volume? {
        didSet {
            updateViews()
        }
    }
    var volumeController: VolumeController?
    var bookshelfController: BookshelfController?
    @IBOutlet weak var bookImageView: UIImageView!
}
