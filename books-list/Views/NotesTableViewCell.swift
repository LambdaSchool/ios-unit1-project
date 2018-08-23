//
//  NotesTableViewCell.swift
//  books-list
//
//  Created by De MicheliStefano on 23.08.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class NotesTableViewCell: UITableViewCell {

    var note: Note? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet weak var noteTextLabel: UILabel!
    
    func updateViews() {
        noteTextLabel?.text = note?.text
    }
    
}
