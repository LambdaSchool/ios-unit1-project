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
  @IBOutlet var segmentedControl: UISegmentedControl!
  @IBOutlet var searchBar: UISearchBar!
  var flag = true
  
  override func viewDidLoad() {
    super.viewDidLoad()
    segmentedControl.layer.cornerRadius = 0
    segmentedControl.layer.borderWidth = 1
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
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
    if section == 1 && flag {
      return "Read"
    } else if section == 0 && flag {
      return "To Read"
    } else {
      return ""
    }
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return fetchedResultsController.sections?.count ?? 0
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
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    guard let searchTerm = searchBar.text else { return }
    if !searchTerm.isEmpty {
      let predicateTitle = NSPredicate(format: "title contains %@", searchTerm)
      let predicateAuthor = NSPredicate(format: "author contains %@", searchTerm)
      let predicateSynopsis = NSPredicate(format: "synopsis contains %@", searchTerm)
      let allPredicates = NSCompoundPredicate(type: .or, subpredicates: [predicateTitle,
                                                                         predicateAuthor,
                                                                         predicateSynopsis])
      
      fetchedResultsController.fetchRequest.predicate = allPredicates
      
      do {
        try self.fetchedResultsController.performFetch()
      } catch {
        NSLog("Error performing search with CoreData")
      }
    } else {
      fetchedResultsController.fetchRequest.predicate = nil
      do {
        try self.fetchedResultsController.performFetch()
      } catch {
        NSLog("Error performing all search with CoreData")
      }
    }
    
    tableView.reloadData()
  }
  
  @IBAction func segmentedControlAction(_ sender: Any) {
    let selectedSegment = segmentedControl.selectedSegmentIndex
    switch selectedSegment {
    case 0:
      fetchedResultsController.fetchRequest.predicate = nil
      flag = true
    case 1:
      let predicate = NSPredicate(format: "hasRead == %@", NSNumber(booleanLiteral: true))
      fetchedResultsController.fetchRequest.predicate = predicate
      flag = false
    case 2:
      let predicate = NSPredicate(format: "hasRead == %@", NSNumber(booleanLiteral: false))
      fetchedResultsController.fetchRequest.predicate = predicate
      flag = false
    default:
      fetchedResultsController.fetchRequest.predicate = nil
      flag = true
    }
    
    do {
      try self.fetchedResultsController.performFetch()
    } catch {
      NSLog("Error performing fetch from CoreData")
    }
    
    tableView.reloadData()
  }
  
  let bookController = BookController()
  
  lazy var fetchedResultsController: NSFetchedResultsController<Book> = {
    let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()
    
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "hasRead", ascending: true), NSSortDescriptor(key: "title", ascending: true)
    ]
    
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
