//
//  ViewBookshelfCollectionViewController.swift
//  Books
//
//  Created by Daniela Parra on 9/24/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import UIKit
import CoreData

class ViewBookshelfCollectionViewController: UICollectionViewController, VolumeCollectionViewCellDelegate, NSFetchedResultsControllerDelegate {
    
    // MARK: - Lifecycle Methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView.reloadData()
    }
    
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
        guard let volumes = fetchedResultsController.fetchedObjects else { return UICollectionViewCell()}
        
        cell.delegate = self
        cell.volume = volumes[indexPath.row]
        cell.volumeController = volumeController
    
        return cell
    }
    
    // MARK: - VolumeCollectionViewCellDelegate
    
    func clickedHaveReadButton(on cell: VolumeCollectionViewCell) {
        
        guard let volume = cell.volume else { return }
        
        volumeController?.changeVolumeReadStatus(volume: volume, oldStatus: volume.hasRead)
        
        collectionView.reloadData()
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
            
            //Pass variables to the next view controller.
            guard let volumes = fetchedResultsController.fetchedObjects else { return }
            destinationVC.volume = volumes[indexPath.row]
            destinationVC.bookshelf = bookshelf
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
    
    lazy var fetchedResultsController: NSFetchedResultsController<Volume> = {
        let fetchRequest: NSFetchRequest<Volume> = Volume.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let moc = CoreDataStack.shared.mainContext
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        
        frc.delegate = self
        try! frc.performFetch()
        return frc
    }()
    
    //Contains
}
