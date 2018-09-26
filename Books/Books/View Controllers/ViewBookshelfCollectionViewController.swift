//
//  ViewBookshelfCollectionViewController.swift
//  Books
//
//  Created by Daniela Parra on 9/24/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import UIKit

private let reuseIdentifier = "BookCell"

class ViewBookshelfCollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            
        guard let bookshelf = bookshelf else { return }
        
        title = bookshelf.title
            
    }
    
    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return volumeController?.volumes.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! VolumeCollectionViewCell
        
        //there's gotta be a better way.
        let volumeRepresentation = volumeController?.volumes[indexPath.item]
        let volume = Volume(volumeRepresentation: volumeRepresentation!)
        
        cell.volume = volume
        cell.volumeController = volumeController
    
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewBook" {
            guard let destinationVC = segue.destination as? BookDetailViewController, let indexPath = collectionView.indexPathsForSelectedItems?.first else { return }
            
            
            let volumeRepresentation = volumeController?.volumes[indexPath.item]
            let volume = Volume(volumeRepresentation: volumeRepresentation!)
            destinationVC.volume = volume
            destinationVC.volumeController = volumeController
        }
    }

    // MARK: - Properties
    
    var bookshelf: Bookshelf? {
        didSet{
            
        }
    }
    var bookshelfController: BookshelfController?
    var volumeController: VolumeController?
    
}
