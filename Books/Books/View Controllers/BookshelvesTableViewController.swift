//
//  BookshelvesTableViewController.swift
//  Books
//
//  Created by Linh Bouniol on 8/21/18.
//  Copyright © 2018 Linh Bouniol. All rights reserved.
//

import UIKit
import CoreData

class BookshelvesTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    // MARK: - Properties
    
    let bookController = BookController()
    
    @IBAction func addBookshelf(_ sender: Any) {
        
        let alert = UIAlertController(title: "New Bookshelf", message: nil, preferredStyle: .alert)
        alert.addTextField { (titleTextField) in
            titleTextField.placeholder = "Bookshelf Name:"
        }
        
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (action) in
            guard let name = alert.textFields![0].text, name.count > 0 else { return }
            
            self.bookController.createBookshelf(with: name)
            
            self.tableView.reloadData()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Want authorization the first time the app launches, viewDidLoad will only get called once when the app launches
        
        GoogleBooksAuthorizationClient.shared.authorizeIfNeeded(presenter: self) { (error) in
            if let error = error {
                NSLog("Authorization failed: \(error)")
                return
            }
            
            // Once the authorization is given, you want to get the bookshelves for that user
            self.bookController.fetchBookshelvesFromGoogleServer()
        }
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        self.bookController.fetchBookshelvesFromGoogleServer()
//    }
    
    lazy var fetchedResultsController: NSFetchedResultsController<Bookshelf> = {
        
        let fetchRequest: NSFetchRequest<Bookshelf> = Bookshelf.fetchRequest()
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "sectionText", ascending: true),
                                        NSSortDescriptor(key: "identifier", ascending: true),
                                        NSSortDescriptor(key: "name", ascending: true)]
        
        let moc = CoreDataStack.shared.mainContext
       
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: moc,
                                             sectionNameKeyPath: "sectionText",
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
            //            tableView.moveRow(at: oldIndexPath, to:  newIndexPath)
            // Doesn't work any more?
            tableView.deleteRows(at: [oldIndexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return fetchedResultsController.sections?[section].name
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookshelfCell", for: indexPath)

        let bookshelf = fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = bookshelf.name
        
        if bookshelf.identifier != nil {    // bookshelf exists on google server
            cell.detailTextLabel?.text = nil
        } else {
            cell.detailTextLabel?.text = "Local Bookshelf"
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // if bookshelf has an id, we can't delete it (bookshelf you create doesn't have an id, but the one from the server does
        
        let bookshelf = fetchedResultsController.object(at: indexPath)
        
        return bookshelf.identifier == nil // if this is true, delete is enabled
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let bookshelf = fetchedResultsController.object(at: indexPath)
            bookController.delete(bookshelf: bookshelf)
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let booksTVC = segue.destination as? BooksTableViewController {
            booksTVC.bookController = bookController
            
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            booksTVC.bookshelf = fetchedResultsController.object(at: indexPath)
            
//            if segue.identifier == "ShowBookshelfDetail" {
//                guard let indexPath = tableView.indexPathForSelectedRow else { return }
//                booksTVC.bookshelf = fetchedResultsController.object(at: indexPath)
//            }
        }
    }
}
