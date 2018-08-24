//
//  BooksTableViewController.swift
//  Books
//
//  Created by Linh Bouniol on 8/21/18.
//  Copyright © 2018 Linh Bouniol. All rights reserved.
//

import UIKit
import CoreData

class BooksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate, BookTableViewCellDelegate, BookCollectionViewCellDelegate, NSFetchedResultsControllerDelegate {
    
    var bookController: BookController?
    
    var bookshelf: Bookshelf? {
        didSet {
            guard let bookshelf = bookshelf else { return }
            bookController?.fetchBooksFromGoogleServer(in: bookshelf)
            
            updateViews()
        }
    }
    
    var lastSelectedBook: Book?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var renameBookshelf: UIBarButtonItem!
    @IBOutlet weak var viewPreferenceSegmentedControl: UISegmentedControl!
    
    @IBAction func toggleViewPreference(_ sender: Any) {
        
        switch viewPreferenceSegmentedControl.selectedSegmentIndex {
        case 0:
            tableView.isHidden = false
            collectionView.isHidden = true
        case 1:
            tableView.isHidden = true
            collectionView.isHidden = false
        default:
            break
        }
    }
    
    @IBAction func renameBookshelf(_ sender: Any) {
        
        let alert = UIAlertController(title: "Rename Bookshelf", message: nil, preferredStyle: .alert)
        alert.addTextField { (titleTextField) in
            titleTextField.placeholder = "Bookshelf Name:"
            
            // Current name before you change it
            titleTextField.text = self.bookshelf?.name
        }
        
        alert.addAction(UIAlertAction(title: "Rename", style: .default, handler: { (action) in
            guard let newName = alert.textFields![0].text, newName.count > 0, let bookshelf = self.bookshelf else { return }
            
            self.bookController?.rename(bookshelf: bookshelf, with: newName)
            
            // current name after you change it
            self.navigationItem.title = bookshelf.name
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//        tableView.reloadData()
//    }     fetchedResultsController takes care of reloading
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
        
        toggleViewPreference(self)
    }
    
    func updateViews() {
        
        // If the bookshelf is a google bookshelf, disable renameBookshelf()
        if (bookshelf?.identifier) != nil {
            renameBookshelf.isEnabled = false
        } else {
            renameBookshelf.isEnabled = true
        }
        
        navigationItem.title = bookshelf?.name
    }
    
    
    func moreInfoButtonWasTapped(for cell: BookTableViewCell) {
        guard let book = cell.book else { return }
    
        showMoreInfoSheet(for: book)
        
    }
    
    func moreInfoButtonWasTapped(for cell: BookCollectionViewCell) {
        guard let book = cell.book else { return }
        
        showMoreInfoSheet(for: book)
    }
    
    func showMoreInfoSheet(for book: Book) {
        lastSelectedBook = book
        
        let actionSheet = UIAlertController(title: "Book Actions", message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: book.hasRead ? "Mark as Unread" : "Mark as Read", style: .default, handler: { (action) in
            self.bookController?.toggleHasRead(for: book)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Move to Bookshelf…", style: .default, handler: { (action) in
            self.performSegue(withIdentifier: "ShowMoveVC", sender: self)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Add to Bookshelf…", style: .default, handler: { (action) in
            self.performSegue(withIdentifier: "ShowAddVC", sender: self)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController<Book> = {
        // Create fetchRequest from Book object
        let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()
        
        // Filter all books to just the ones in that bookshelf
        fetchRequest.predicate = NSPredicate(format: "bookshelves CONTAINS %@", bookshelf!)
        
        // Sort the entries based on hasRead
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "hasRead", ascending: true),
                                        NSSortDescriptor(key: "title", ascending: true)]
        
        // Get CoreDataStack's mainContext
        let moc = CoreDataStack.shared.mainContext
        
        // Initialize NSFetchedResultsController
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: moc,
                                             sectionNameKeyPath: "hasRead",
                                             cacheName: nil)
        // Set this VC as frc's delegate
        frc.delegate = self
        
        try! frc.performFetch()
        
        return frc
    }()
    
    // MARK: - NSFetchedResultsControllerDelegate with CollectionView
    
//    private var blockOperations: [BlockOperation] = []
//
//    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        blockOperations.removeAll(keepingCapacity: false)
//    }
//
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
//                    didChange anObject: Any,
//                    at indexPath: IndexPath?,
//                    for type: NSFetchedResultsChangeType,
//                    newIndexPath: IndexPath?) {
//
//        let op: BlockOperation
//        switch type {
//        case .insert:
//            guard let newIndexPath = newIndexPath else { return }
//            op = BlockOperation { self.collectionView?.insertItems(at: [newIndexPath]) }
//        case .delete:
//            guard let indexPath = indexPath else { return }
//            op = BlockOperation { self.collectionView?.deleteItems(at: [indexPath]) }
//        case .update:
//            guard let indexPath = indexPath else { return }
//            op = BlockOperation { self.collectionView?.reloadItems(at: [indexPath]) }
//        case .move:
//            guard let indexPath = indexPath,  let newIndexPath = newIndexPath else { return }
//            op = BlockOperation { self.collectionView?.moveItem(at: indexPath, to: newIndexPath) }
//        }
//
//        blockOperations.append(op)
//    }
//
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
//
//        var op: BlockOperation?
//        switch type {
//        case .insert:
//            op = BlockOperation { self.collectionView?.insertSections(IndexSet(integer: sectionIndex)) }
//        case .delete:
//            op = BlockOperation { self.collectionView?.deleteSections(IndexSet(integer: sectionIndex)) }
//        default:
//            break
//        }
//
//        guard let newOp = op else { return }
//        blockOperations.append(newOp)
//    }
//
//    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        collectionView?.performBatchUpdates({
//            self.blockOperations.forEach { $0.start() }
//        }, completion: { finished in
//            self.blockOperations.removeAll(keepingCapacity: false)
//        })
//    }
    
    // MARK: - NSFetchedResultsControllerDelegate with TableView
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        collectionView.reloadData()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        // NSFetchedResultsChangeType has four types: insert, delete, move, update
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard let oldIndexPath = indexPath, let newIndexPath = newIndexPath else { return }
            tableView.moveRow(at: oldIndexPath, to: newIndexPath)
            // Doesn't work any more?
//            tableView.deleteRows(at: [oldIndexPath], with: .automatic)
//            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }
    
    // MARK: - CollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! BookCollectionViewCell

        cell.book = fetchedResultsController.object(at: indexPath)
        cell.delegate = self

        return cell
    }



    // MARK: - TableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionInfo = fetchedResultsController.sections?[section]
        
        if sectionInfo?.name == "0" {
            return "Unread"
        } else {
            return "Read"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as! BookTableViewCell

        cell.book = fetchedResultsController.object(at: indexPath)
        cell.delegate = self
    
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let book = fetchedResultsController.object(at: indexPath)
            bookController?.delete(book: book, from: bookshelf)
            
            // fetchedResultsController takes care of reloading
//            tableView.reloadData()
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let searchVC = segue.destination as? SearchBooksTableViewController {
            searchVC.bookController = bookController
            searchVC.bookshelf = bookshelf
        }
        
        if let bookDetailVC = segue.destination as? BookDetailViewController {
            bookDetailVC.bookController = bookController
            
            if segue.identifier == "ShowBookDetail" {
                guard let indexPath = tableView.indexPathForSelectedRow else { return }
                bookDetailVC.book = fetchedResultsController.object(at: indexPath)
            } else if segue.identifier == "ShowCollectionBookDetail" {
                guard let indexPath = collectionView.indexPathsForSelectedItems?.first else { return }
                bookDetailVC.book = fetchedResultsController.object(at: indexPath)
            }
        }
        
        if let moveToVC = segue.destination as? MoveToTableViewController {
            moveToVC.bookController = bookController
            moveToVC.book = lastSelectedBook
            
            // When moving book to another bookshelf, we want to have a currentBookshelf to remove it from. When we add book to another bookshelf, we don't want to remove the book from the currentBookshelf so let it as nil.
            
            if segue.identifier == "ShowMoveVC" {
                moveToVC.currentBookshelf = bookshelf
            }
        }
    }
}
