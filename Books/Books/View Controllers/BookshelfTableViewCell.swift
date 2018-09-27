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
    func setCollectionViewDataSourceDelegate
        <D: UICollectionViewDataSource & UICollectionViewDelegate>
        (dataSourceDelegate: D, forRow row: Int) {
        
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        collectionView.reloadData()
    }
    
    var bookshelf: Bookshelf? {
        didSet{
            updateViews()
        }
    }
    var volumeController: VolumeController?
    var bookshelfController: BookshelfController?
    
    @IBOutlet weak var bookshelfTitleLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    
}

//extension UITableViewCell: UICollectionViewDataSource {
//    
//    //Set up number of items in section for nested collection view
//    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 0
//    }
//    
//    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VolumeInBookshelfCell", for: indexPath) as! BookshelfVolumeCollectionViewCell
//        
//        // Configure the cell
//        
//        return cell
//}

/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

//    var bookshelf: Bookshelf?
//    var bookshelfController: BookshelfController?
//    var volumeController: VolumeController?

