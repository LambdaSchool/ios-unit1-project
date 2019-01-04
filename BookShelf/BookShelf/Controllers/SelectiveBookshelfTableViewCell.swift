//
//  SelectiveBookshelfTableViewCell.swift
//  BookShelf
//
//  Created by Austin Cole on 1/4/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

import UIKit

class SelectiveBookshelfTableViewCell: UITableViewCell {
    @IBOutlet weak var bookshelfNameLabel: UILabel!
    @IBOutlet weak var bookshelfBookImageLeft: UIImageView!
    @IBOutlet weak var bookshelfBookImageCenter: UIImageView!
    @IBOutlet weak var bookshelfBookImageRight: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
