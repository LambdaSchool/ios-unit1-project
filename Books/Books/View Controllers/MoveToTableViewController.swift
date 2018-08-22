//
//  MoveToTableViewController.swift
//  Books
//
//  Created by Linh Bouniol on 8/22/18.
//  Copyright © 2018 Linh Bouniol. All rights reserved.
//

import UIKit
import CoreData

class MoveToTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var book: Book?
    var bookController: BookController?
    
    @IBAction func addBookshelf(_ sender: Any) {
        
        let alert = UIAlertController(title: "New Bookshelf", message: nil, preferredStyle: .alert)
        alert.addTextField { (titleTextField) in
            titleTextField.placeholder = "Bookshelf Name:"
        }
        
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (action) in
            guard let name = alert.textFields![0].text, name.count > 0 else { return }
            
            self.bookController?.createBookshelf(with: name)
            
            self.tableView.reloadData()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }

    lazy var fetchedResultsController: NSFetchedResultsController<Bookshelf> = {
        
        let fetchRequest: NSFetchRequest<Bookshelf> = Bookshelf.fetchRequest()
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        let moc = CoreDataStack.shared.mainContext
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: moc,
                                             sectionNameKeyPath: nil,
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
            tableView.moveRow(at: oldIndexPath, to:  newIndexPath)
            // Doesn't work any more?
//            tableView.deleteRows(at: [oldIndexPath], with: .automatic)
//            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShowMoveVC", for: indexPath)

        let bookshelf = fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = bookshelf.name

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let book = book else { return }
        let bookshelf = fetchedResultsController.object(at: indexPath)
        bookController?.move(book: book, to: bookshelf)
        
        navigationController?.popViewController(animated: true)
    }
}
