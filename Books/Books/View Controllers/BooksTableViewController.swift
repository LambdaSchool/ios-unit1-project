//
//  BooksTableViewController.swift
//  Books
//
//  Created by Linh Bouniol on 8/21/18.
//  Copyright © 2018 Linh Bouniol. All rights reserved.
//

import UIKit
import CoreData

class BooksTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, BookTableViewCellDelegate, NSFetchedResultsControllerDelegate {
    
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
    @IBOutlet weak var renameBookshelf: UIBarButtonItem!
    
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
        // Create fetchRequest from Entry object
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
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
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

    // MARK: - Table view data source
    
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
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            bookDetailVC.book = fetchedResultsController.object(at: indexPath)
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
