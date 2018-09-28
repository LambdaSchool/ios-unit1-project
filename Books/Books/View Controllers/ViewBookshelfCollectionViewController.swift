//
//  ViewBookshelfCollectionViewController.swift
//  Books
//
//  Created by Daniela Parra on 9/24/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import UIKit
import CoreData

class ViewBookshelfCollectionViewController: UICollectionViewController, VolumeCollectionViewCellDelegate {
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let bookshelf = bookshelf else { return }
        bookshelfController?.fetchVolumesforBookshelfFromServer(bookshelf: bookshelf, completion: { (_) in
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        })
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookshelf?.volumes?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VolumeCell", for: indexPath) as! VolumeCollectionViewCell
        
        //Pass variable to the cell to display image
        guard let bookshelf = bookshelf else { return UICollectionViewCell() }
        
        cell.volume = bookshelf.volumes?.object(at: indexPath.row) as! Volume
        cell.volumeController = volumeController
    
        return cell
    }
    
    // MARK: - VolumeCollectionViewCellDelegate
    
    func clickedHaveReadButton(on cell: VolumeCollectionViewCell) {
        
        guard let volume = cell.volume else { return }
        
        volumeController?.changeVolumeReadStatus(volume: volume, oldStatus: volume.hasRead)
    }
    
    // MARK: - Private Methods
    
    private func updateViews() {
        guard let bookshelf = bookshelf else { return }
        
        title = bookshelf.title
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewBook" {
            guard let destinationVC = segue.destination as? BookDetailViewController, let indexPath = collectionView.indexPathsForSelectedItems?.first else { return }
            
            
            destinationVC.volume = bookshelf?.volumes?.object(at: indexPath.row) as! Volume
            destinationVC.volumeController = volumeController
        }
    }

    // MARK: - Properties
    
    var bookshelf: Bookshelf? {
        didSet{
            updateViews()
        }
    }
    var bookshelfController: BookshelfController?
    var volumeController: VolumeController?
    
    //LAZY VARIABLE
    
    //Contains
}
