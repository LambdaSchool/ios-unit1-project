//
//  BookshelfTableViewCell.swift
//  Books
//
//  Created by Daniela Parra on 9/26/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import UIKit
import CoreData

class BookshelfTableViewCell: UITableViewCell, NSFetchedResultsControllerDelegate {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func updateViews() {
        guard let bookshelf = bookshelf else { return }
        
        bookshelfTitleLabel.text = bookshelf.title
    }
    
    // MARK: - Properties
    var bookshelf: Bookshelf? {
        didSet{
            updateViews()
        }
    }
    var volumeController: VolumeController?
    var bookshelfController: BookshelfController?
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
    
    @IBOutlet weak var bookshelfTitleLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    
}

extension BookshelfTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    //Set up number of items in section for nested collection view
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VolumeInBookshelfCell", for: indexPath) as! BookshelfVolumeCollectionViewCell
        
        
        guard let volumes = fetchedResultsController.fetchedObjects else { return UICollectionViewCell()}
        cell.volume = volumes[indexPath.row]
        
        return cell
    }
}
