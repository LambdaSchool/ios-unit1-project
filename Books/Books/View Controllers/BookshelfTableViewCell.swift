//
//  BookshelfTableViewCell.swift
//  Books
//
//  Created by Daniela Parra on 9/26/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import UIKit

class BookshelfTableViewCell: UITableViewCell {
    
    private func updateViews() {
        guard let bookshelf = bookshelf else { return }
        
        bookshelfTitleLabel.text = bookshelf.title
    }
    
    //To connect table view cell to collection view cell.
    func registerCollectionView<DataSource: UICollectionViewDataSource>(datasource: DataSource) {
        self.collectionView.dataSource = datasource
    }
    
    var bookshelf: Bookshelf? {
        didSet{
            updateViews()
        }
    }
    var volumeController: VolumeController?
    var bookshelfController: BookshelfController?
    
    @IBOutlet weak var bookshelfTitleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
}
