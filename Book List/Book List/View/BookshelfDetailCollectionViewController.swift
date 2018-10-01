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

class BookshelfDetailCollectionViewController: UICollectionViewController, NSFetchedResultsControllerDelegate, UICollectionViewDelegateFlowLayout, BookCollectionViewCellDelegate {
    
    var bookshelf: Bookshelf?
    let bookController = BookController()
    var bookshelfController: BookshelfController?
    
    func setupFRC() {
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
        self.fetchedResultsController = fetchedResultsController
    }
    
    var fetchedResultsController: NSFetchedResultsController<Book>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFRC()
        title = bookshelf?.title?.capitalized
        
        navigationItem.rightBarButtonItem = editButtonItem
        
        if let bookshelf = bookshelf {
            bookshelfController?.fetchBooks(for: bookshelf) { (_) in
            }
        }
    }

    // MARK: UI Collection View Data Source
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController?.fetchedObjects?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! BookCollectionViewCell
        let book = fetchedResultsController?.object(at: indexPath)
        
        cell.book = book
        cell.isEditing = isEditing
        cell.delegate = self
        
        return cell
    }
    
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
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        let indexPaths = collectionView.indexPathsForVisibleItems
        for indexPath in indexPaths {
            if let cell = collectionView.cellForItem(at: indexPath) as? BookCollectionViewCell {
               cell.isEditing = editing
            }
        }
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
    
    // MARK: - Book Collection View Cell
    func deleteBook(_ book: Book) {
        guard let bookshelf = bookshelf else { return }
        bookController.remove(book: book, from: bookshelf)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowBookSegue" {
            guard let destinationVC = segue.destination as? BookDetailViewController,
                let indexPath = collectionView.indexPathsForSelectedItems?.first else { return }
            let book = fetchedResultsController?.object(at: indexPath)
            
            destinationVC.book = book
        }
    }
    
    // MARK: - Utility Methods
    private func updateImages() {
        for book in fetchedResultsController?.fetchedObjects ?? [] {
            bookController.fetchImagesFor(book: book)
            //            bookController.fetchImageFor(book: book)
        }
    }
    
}
