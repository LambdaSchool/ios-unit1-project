//
//  AddToCollectionsTableViewController.swift
//  books-list
//
//  Created by De MicheliStefano on 21.08.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit
import CoreData

class AddToCollectionsTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, AddToCollectionsDelegate {

    // MARK: - Properties
    
    var book: Book?
    let collectionController = CollectionController()
    
    @IBOutlet weak var titleTextField: UITextField!
    
    lazy var fetchedResultsController: NSFetchedResultsController<Collection> = {
        let fetchRequest: NSFetchRequest<Collection> = Collection.fetchRequest()
        let sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        let moc = CoreDataStack.shared.mainContext
        fetchRequest.sortDescriptors = sortDescriptors
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                   managedObjectContext: moc,
                                   sectionNameKeyPath: nil,
                                   cacheName: nil)
        frc.delegate = self
        do {
            try frc.performFetch()
        } catch {
            NSLog("Error fetching collections...")
        }
        
        return frc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Methods
    @IBAction func save(_ sender: Any) {
        guard var title = titleTextField?.text else { return }
        collectionController.create(title: title)
        title = ""
    }
    
    func addToCollection(_ book: Book) {
        // TODO: add a book to a collection
    }
    

    // MARK: - NSFetchResultsController
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
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
            guard let newIndexPath = newIndexPath, let oldIndexPath = indexPath else { return }
            tableView.deleteRows(at: [oldIndexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionCell", for: indexPath) as! AddToCollectionsTableViewCell

        cell.collection = fetchedResultsController.object(at: indexPath)
        // TODO: pass in the book which needs to be added to collections
        // pass book via segue
        // TODO: insert editing style when adding new collection: https://www.youtube.com/watch?v=MC4mDQ7UqEE
        cell.delegate = self

        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    

}
