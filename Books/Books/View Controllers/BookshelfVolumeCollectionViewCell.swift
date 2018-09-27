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
        //Set image of volume
//        volumeController?.displayImage(volume: volume, imageView: )
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
