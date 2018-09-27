//
//  ViewBookshelfCollectionViewController.swift
//  Books
//
//  Created by Daniela Parra on 9/24/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "VolumeCell"

class ViewBookshelfCollectionViewController: UICollectionViewController, NSFetchedResultsControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let bookshelf = bookshelf else { return }
        
        bookshelfController?.fetchVolumesforBookshelfFromServer(bookshelf: bookshelf, completion: { (_) in
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            
        guard let bookshelf = bookshelf else { return }
        
        title = bookshelf.title    
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
    
    func updateViews() {
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
    
    lazy var fetchedResultsController: NSFetchedResultsController<Bookshelf> = {
        let fetchRequest: NSFetchRequest<Bookshelf> = Bookshelf.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let moc = CoreDataStack.shared.mainContext
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        
        frc.delegate = self
        try! frc.performFetch()
        return frc
    }()
}
