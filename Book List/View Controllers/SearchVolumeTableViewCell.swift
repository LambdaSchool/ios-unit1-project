//
//  SearchVolumeTableViewCell.swift
//  Book List
//
//  Created by Moin Uddin on 9/25/18.
//  Copyright © 2018 Moin Uddin. All rights reserved.
//

import UIKit


protocol SearchVolumeTableViewCellDelegate: class {
    func addVolume(volumeRep: VolumeRepresentation)
}
class SearchVolumeTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateViews() {
        guard let volumeRep = volumeRep else { return }
        volumeNameLabel.text = volumeRep.volumeInfo.title
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBOutlet weak var volumeNameLabel: UILabel!
    
    
 
    
    @IBAction func addVolume(_ sender: Any) {
        guard let volumeRep = volumeRep else { return }
        delegate?.addVolume(volumeRep: volumeRep)
    }
    
    var delegate: SearchVolumeTableViewCellDelegate?
    
    var volumeRep: VolumeRepresentation? {
        didSet {
            updateViews()
        }
    }
    
    
}
