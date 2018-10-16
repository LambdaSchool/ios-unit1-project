//
//  BookshelfVolumeCollectionViewCell.swift
//  Books
//
//  Created by Daniela Parra on 9/26/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import UIKit

class BookshelfVolumeCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Private Methods
    
    //Set up custom collection view cell with data from volume
    private func updateViews() {
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
    
    // MARK: - Properties
    var volume: Volume? {
        didSet {
            updateViews()
        }
    }
    var volumeController: VolumeController?
    
    @IBOutlet weak var bookImageView: UIImageView!
}
