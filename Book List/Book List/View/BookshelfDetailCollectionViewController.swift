//
//  BookshelfDetailCollectionViewController.swift
//  Book List
//
//  Created by Dillon McElhinney on 9/24/18.
//  Copyright © 2018 Dillon McElhinney. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "BookCell"

class BookshelfDetailCollectionViewController: UICollectionViewController, NSFetchedResultsControllerDelegate, UICollectionViewDelegateFlowLayout {
    
    var bookshelf: Bookshelf?
    let bookController = BookController()
    var bookshelfController: BookshelfController?
    
    lazy var fetchedResultsController: NSFetchedResultsController<Book> = {
        let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        if let bookshelf = bookshelf {
            let predicate = NSPredicate(format: "bookshelves CONTAINS %@", bookshelf)
            fetchRequest.predicate = predicate
        }
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.mainContext, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        
        try! fetchedResultsController.performFetch()
        return fetchedResultsController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = bookshelf?.title?.capitalized
        
        if let bookshelf = bookshelf {
            bookshelfController?.fetchBooks(for: bookshelf) { (_) in
//                guard let books = self.fetchedResultsController.fetchedObjects else { return }
//                for book in books {
//                    self.bookController.fetchThumbnailFor(book: book)
//                }
            }
        }
    }

    // MARK: UI Collection View Data Source
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! BookCollectionViewCell
        let book = fetchedResultsController.object(at: indexPath)
        
        cell.book = book
    
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
    
    // MARK: - UI Collection View Delegate Flow Layout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = (collectionView.frame.width / 3) - 20
        let itemHeight = itemWidth * 1.5
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    // MARK: - NS Fetched Results Controller
    private var sectionChanges = [(type: NSFetchedResultsChangeType, sectionIndex: Int)]()
    private var itemChanges = [(type: NSFetchedResultsChangeType, indexPath: IndexPath?, newIndexPath: IndexPath?)]()
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        sectionChanges.append((type, sectionIndex))
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?)
    {
        itemChanges.append((type, indexPath, newIndexPath))
        if let indexPath = indexPath {
            let book = fetchedResultsController.object(at: indexPath)
            bookController.fetchThumbnailFor(book: book)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        collectionView?.performBatchUpdates({
            
            for change in self.sectionChanges {
                switch change.type {
                case .insert: self.collectionView?.insertSections([change.sectionIndex])
                case .delete: self.collectionView?.deleteSections([change.sectionIndex])
                default: break
                }
            }
            
            for change in self.itemChanges {
                switch change.type {
                case .insert:
                    guard let newIndexPath = change.newIndexPath else { break }
                    self.collectionView?.insertItems(at: [newIndexPath])
                case .delete:
                    guard let indexPath = change.indexPath else { break }
                    self.collectionView?.deleteItems(at: [indexPath])
                case .update:
                    guard let indexPath = change.indexPath else { break }
                    self.collectionView?.reloadItems(at: [indexPath])
                case .move:
                    guard let indexPath = change.indexPath,
                        let newIndexPath = change.newIndexPath else { break }
                    self.collectionView?.deleteItems(at: [indexPath])
                    self.collectionView?.insertItems(at: [newIndexPath])
                }
            }
            
        }, completion: { finished in
            self.sectionChanges.removeAll()
            self.itemChanges.removeAll()
        })
    }

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowBookSegue" {
            guard let destinationVC = segue.destination as? BookDetailViewController,
                let indexPath = collectionView.indexPathsForSelectedItems?.first else { return }
            let book = fetchedResultsController.object(at: indexPath)
            
            destinationVC.book = book
        }
    }
    
    // MARK: - Utility Methods
    private func updateImages() {
        for book in fetchedResultsController.fetchedObjects ?? [] {
            bookController.fetchThumbnailFor(book: book)
//            bookController.fetchImageFor(book: book)
        }
    }

}
