//
//  CollectionsCollectionViewController.swift
//  books-list
//
//  Created by De MicheliStefano on 23.08.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "BookCollectionCell"

class CollectionsCollectionViewController: UICollectionViewController, CollectionControllerProtocol, BookControllerProtocol,  NSFetchedResultsControllerDelegate {

    
    // MARK: - Properties
    
    var collectionController: CollectionController?
    var bookController: BookController?
    private var blockOperations: [BlockOperation] = []
    
    lazy var fetchedResultsController: NSFetchedResultsController<Collection> = {
        let fetchRequest: NSFetchRequest<Collection> = Collection.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        let moc = CoreDataStack.shared.mainContext
        
        var frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                   managedObjectContext: moc,
                                   sectionNameKeyPath: "title",
                                   cacheName: nil)
        frc.delegate = self
        try! frc.performFetch()
        return frc
    }()
    
    // MARK: - NSFetchedResultsController
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        blockOperations.removeAll(keepingCapacity: false)
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView?.performBatchUpdates({ self.blockOperations.forEach { $0.start() } }, completion: { finished in
            self.blockOperations.removeAll(keepingCapacity: false)
        })
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        var bo: BlockOperation?
        
        switch type {
        case .insert:
            bo = BlockOperation { self.collectionView.insertSections(IndexSet(integer: sectionIndex)) }
        case .delete:
            bo = BlockOperation { self.collectionView.deleteSections(IndexSet(integer: sectionIndex)) }
        default:
            break
        }
        
        guard let newBo = bo else { return }
        blockOperations.append(newBo)
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        var bo: BlockOperation
        
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            bo = BlockOperation { self.collectionView.insertItems(at: [newIndexPath]) }
        case .delete:
            guard let indexPath = indexPath else { return }
            bo = BlockOperation { self.collectionView.deleteItems(at: [indexPath]) }
        case .update:
            guard let indexPath = indexPath else { return }
            bo = BlockOperation { self.collectionView.reloadItems(at: [indexPath]) }
        case .move:
            guard let newIndexPath = newIndexPath, let oldIndexPath = indexPath else { return }
            bo = BlockOperation {
                self.collectionView.deleteItems(at: [oldIndexPath])
                self.collectionView.insertItems(at: [newIndexPath])
            }
        }
        
        blockOperations.append(bo)
    }
    
    // MARK: - Methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CollectionSection", for: indexPath) as? CollectionsCollectionReusableView {
            sectionHeader.collectionSectionLabel?.text = fetchedResultsController.fetchedObjects?[indexPath.section].title
            return sectionHeader
        }
        return UICollectionReusableView()
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?[section].books?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionsCollectionViewCell
    
        let collection = fetchedResultsController.fetchedObjects?[indexPath.section]
        
        guard let book = collection?.books?.allObjects[indexPath.row] as? Book,
            let image = book.image else { return cell }
        
        cell.bookImageView?.image = UIImage(data: image)
    
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowBookSummary" {
            let vc = segue.destination as! BookSummaryViewController
            if let indexPath = collectionView.indexPathsForSelectedItems?.first,
                let collection = fetchedResultsController.fetchedObjects?[indexPath.section],
                let book = collection.books?.allObjects[indexPath.row] as? Book {
                
                vc.book = book
                vc.collectionController = collectionController
                vc.bookController = bookController
            }
        } 
    }

}

extension CollectionsCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if collectionView.numberOfItems(inSection: section) == 0 {
            return CGSize.zero
        } else {
            let headerView = self.view.subviews[0].subviews[0] as! UICollectionReusableView
            let existingSize = headerView.frame.size
            
            return existingSize
        }
    }
}
