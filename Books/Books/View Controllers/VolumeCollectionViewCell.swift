
//
//  VolumeCollectionViewCell.swift
//  Books
//
//  Created by Daniela Parra on 9/25/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import UIKit

class VolumeCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Private Methods
    
    private func updateViews() {
        guard let volume = volume else { return }
    
        if volume.hasRead {
            hasReadButton.setTitle("Have Read", for: .normal)
        } else {
            hasReadButton.setTitle("Haven't Read", for: .normal)
        }
        
        volumeController?.displayImage(volume: volume, imageView: bookImageView)
    }
    
    // MARK: - Properties
    
    var volume: Volume? {
        didSet{
            updateViews()
        }
    }
    var volumeController: VolumeController?
    
    @IBOutlet weak var hasReadButton: UIButton!
    @IBOutlet weak var bookImageView: UIImageView!
    
}
