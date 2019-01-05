//
//  BookTableViewCell.swift
//  Books
//
//  Created by Sergey Osipyan on 1/4/19.
//  Copyright © 2019 Sergey Osipyan. All rights reserved.
//

import UIKit

class BookTableViewCell: UITableViewCell {

    @IBOutlet weak var bookLabel: UILabel!
    @IBOutlet weak var buuton: UIButton!
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var bookImage: UIImageView!
    
    @IBAction func action(_ sender: Any) {
        //Model.shared.addNewBook()
       BooksTableViewController().tableView.reloadData()
        
        
    }
}
