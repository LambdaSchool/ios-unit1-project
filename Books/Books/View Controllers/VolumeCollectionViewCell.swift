
//
//  VolumeCollectionViewCell.swift
//  Books
//
//  Created by Daniela Parra on 9/25/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import UIKit

protocol VolumeCollectionViewCellDelegate: class {
    func clickedHaveReadButton(on cell: VolumeCollectionViewCell)
}

class VolumeCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Private Methods
    
    private func updateViews() {
        guard let volume = volume else { return }
    
        if volume.hasRead {
            hasReadButton.setTitle("Have Read", for: .normal)
        } else {
            hasReadButton.setTitle("Haven't Read", for: .normal)
        }
        
        guard let thumbnailString = volume.image else { return }
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
    
    @IBAction func changeHaveReadStatus(_ sender: Any) {
        delegate?.clickedHaveReadButton(on: self)
    }
    
    
    // MARK: - Properties
    
    var volume: Volume? {
        didSet{
            updateViews()
        }
    }
    var volumeController: VolumeController?
    weak var delegate: VolumeCollectionViewCellDelegate?
    
    @IBOutlet weak var hasReadButton: UIButton!
    @IBOutlet weak var bookImageView: UIImageView!
    
}
