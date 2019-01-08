//
//  BookShelvesCollectionViewController.swift
//  BookShelf
//
//  Created by Austin Cole on 1/2/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class BookShelvesCollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Model.shared.updateBookshelves()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Model.shared.updateBookshelves()
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "CollectionDetailViewSegue", sender: self)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as? BookShelvesDetailCollectionViewController
        guard let indexPath = collectionView.indexPathsForSelectedItems else {return}
        let bookshelf = Model.shared.bookshelves.bookshelves[indexPath[0].row]
        destination?.bookshelf = bookshelf
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Model.shared.bookshelves.bookshelves.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? BookShelfCollectionViewCell else {fatalError("Failed to DQ cell")}
        
        
        if let imageURL = Model.shared.bookshelves.bookshelves[indexPath.row].books?.randomElement()?.imageLinks?.thumbnail {
        guard let url = URL(string: (imageURL)) else {fatalError("Could not turn string into url")}
        guard let imageData = try? Data(contentsOf: url) else {fatalError("Could not turn url into data")}
        guard let image = UIImage(data: imageData) else {fatalError("Could not turn data into image")}
            cell.bookshelfImage.image = image
        } else {cell.bookshelfImage.image = UIImage(named: "book_image_not_available")}
        cell.bookshelfLabel.text = Model.shared.bookshelves.bookshelves[indexPath.row].name
        
    
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
