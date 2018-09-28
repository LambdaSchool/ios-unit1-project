//
//  MyBookshelvesTableViewController.swift
//  Books
//
//  Created by Daniela Parra on 9/24/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import UIKit
import CoreData

class MyBookshelvesTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        GoogleBooksAuthorizationClient.shared.authorizeIfNeeded(presenter: self) { (error) in
            if let error = error {
                NSLog("Authorization failed: \(error)")
                return
            }
            self.bookshelfController.fetchBookshelvesFromServer(completion: { (_) in
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
        }
    }

    // MARK: - Table view data source
    
    //Set up number of rows in section for table view.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    //Set up custom cell.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BookshelfDetailCell", for: indexPath) as? BookshelfTableViewCell else { return UITableViewCell() }

        //Pass variables to custom cell.
        let bookshelf = fetchedResultsController.object(at: indexPath)
        cell.bookshelf = bookshelf
        cell.volumeController = volumeController

        return cell
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
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
            guard let indexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            break
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchBooks" {
            guard let destinationVC = segue.destination as? BookSearchTableViewController else { return }
            
            //Pass variable to the book search table view controller.
            destinationVC.volumeController = volumeController
        }
        
        if segue.identifier == "ViewBookshelf" {
            guard let destinationVC = segue.destination as? ViewBookshelfCollectionViewController, let indexPath = tableView.indexPathForSelectedRow else { return }
            
            
            let bookshelf = fetchedResultsController.object(at: indexPath)
            destinationVC.bookshelf = bookshelf
            destinationVC.bookshelfController = bookshelfController
            destinationVC.volumeController = volumeController
            
        }
    }
    
    // MARK: - Properties
    let bookshelfController = BookshelfController()
    let volumeController = VolumeController()
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
