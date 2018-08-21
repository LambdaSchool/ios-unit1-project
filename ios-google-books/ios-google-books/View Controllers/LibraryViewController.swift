//
//  LibraryViewController.swift
//  ios-google-books
//
//  Created by Conner on 8/21/18.
//  Copyright © 2018 Conner. All rights reserved.
//

import UIKit
import CoreData

class LibraryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, NSFetchedResultsControllerDelegate {
  
  @IBOutlet var tableView: UITableView!
  var sections: [String] = ["Read", "To Read"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadData()
  }
  
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.beginUpdates()
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.endUpdates()
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                  didChange sectionInfo: NSFetchedResultsSectionInfo,
                  atSectionIndex sectionIndex: Int,
                  for type: NSFetchedResultsChangeType) {
    
    switch type {
    case .insert:
      tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
    case .delete:
      tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
    default:
      break
    }
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                  didChange anObject: Any,
                  at indexPath: IndexPath?,
                  for type: NSFetchedResultsChangeType,
                  newIndexPath: IndexPath?) {
    
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
      guard let oldIndexPath = indexPath,
        let newIndexPath = newIndexPath else { return }
      tableView.deleteRows(at: [oldIndexPath], with: .automatic)
      tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
    
  }
  
  func tableView(_ tableView: UITableView,
                          titleForHeaderInSection section: Int) -> String? {
    switch section {
    case 0:
      return "Read"
    case 1:
      return "To Read"
    default:
      return "Read"
    }
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return fetchedResultsController.sections?.count ?? 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return fetchedResultsController.sections?[section].numberOfObjects ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as! BookTableViewCell
    let book = fetchedResultsController.object(at: indexPath)
    cell.book = book
    
    return cell
  }
  
  @IBAction func segmentedControlAction(_ sender: Any) {
  }
  
  let bookController = BookController()
  
  lazy var fetchedResultsController: NSFetchedResultsController<Book> = {
    let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()
    
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "hasRead", ascending: true)]
    
    let moc = CoreDataManager.shared.mainContext
    let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                         managedObjectContext: moc,
                                         sectionNameKeyPath: "hasRead",
                                         cacheName: nil)
    frc.delegate = self
    
    try! frc.performFetch()
    
    return frc
  }()
  
}
