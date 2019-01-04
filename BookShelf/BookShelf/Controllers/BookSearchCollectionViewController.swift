//
//  BookSearchCollectionViewController.swift
//  BookShelf
//
//  Created by Austin Cole on 1/2/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class BookSearchCollectionViewController: UICollectionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }

     //MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as? BookDetailViewController
        guard let indexPath = collectionView.indexPathsForSelectedItems else {return}
        let book = Model.shared.volumes?.items[indexPath[0].row].volumeInfo
        
        destination?.book = book
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return Model.shared.numberOfVolumes()
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? BookSearchCollectionViewCell else{fatalError("Could not DQ BookSearchCollectionViewCell")}
        cell.bookImageView.image = UIImage(named: "book_image_not_available")
        if let imageURL = Model.shared.volumes?.items[indexPath.row].volumeInfo.imageLinks?.smallThumbnail {
        guard let url = URL(string: (imageURL)) else {fatalError("Could not turn string into url")}
        guard let imageData = try? Data(contentsOf: url) else {fatalError("Could not turn url into data")}
        cell.bookImageView.image = UIImage(data: imageData)
        }
        
        else if let imageURL = Model.shared.volumes?.items[indexPath.row].volumeInfo.imageLinks?.thumbnail {
            guard let url = URL(string: (imageURL)) else {fatalError("Could not turn string into url")}
            guard let imageData = try? Data(contentsOf: url) else {fatalError("Could not turn url into data")}
            cell.bookImageView.image = UIImage(data: imageData)
        }
        cell.bookTitleLabel.text = Model.shared.volumes?.items[indexPath.row].volumeInfo.title
        return cell
    }
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
