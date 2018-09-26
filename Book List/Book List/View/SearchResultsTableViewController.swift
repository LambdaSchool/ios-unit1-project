//
//  SearchResultsTableViewController.swift
//  Book List
//
//  Created by Dillon McElhinney on 9/24/18.
//  Copyright © 2018 Dillon McElhinney. All rights reserved.
//

import UIKit
import CoreData

class SearchResultsTableViewController: UITableViewController, UISearchResultsUpdating {
    
    let bookSearchController = BookSearchController()
    let bookController = BookController()
    var searchController: UISearchController!
    var objectIDs: [NSManagedObjectID] = []
    
    lazy var tempContext: NSManagedObjectContext = {
        let tempContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        tempContext.parent = CoreDataStack.shared.mainContext
        return tempContext
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initializing with searchResultsController set to use this view controller to display the search results
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Books"
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        // Sets this view controller as presenting view controller for the search interface
        definesPresentationContext = true
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objectIDs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookResultCell", for: indexPath)
        let book = tempContext.object(with: objectIDs[indexPath.row]) as! Book
        
        cell.textLabel?.text = book.title
        cell.detailTextLabel?.text = book.author
        
        if let imageData = book.thumbnailData {
            cell.imageView?.image = UIImage(data: imageData)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (objectIDs.count - 4) {
            let page = objectIDs.count/15
            guard let searchTerm = searchController.searchBar.text else { return }
            bookSearchController.performSearch(with: searchTerm, page: page) { (_) in
                DispatchQueue.main.async {
                    self.updateTableView()
                }
            }
        }
    }
    
    // MARK: - UI Search Results Updating
    func updateSearchResults(for searchController: UISearchController) {
        objectIDs = []
        tempContext.reset()
        URLSession.shared.reset {}
        guard let searchTerm = searchController.searchBar.text, !searchTerm.isEmpty else {
            tableView.reloadData()
            return
        }
        bookSearchController.performSearch(with: searchTerm) { (_) in
            DispatchQueue.main.async {
                self.updateTableView()
            }
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddBookSegue" {
            guard let destinationVC = segue.destination as? BookDetailViewController,
            let indexPath = tableView.indexPathForSelectedRow else { return }
            let objectID = objectIDs[indexPath.row]
            
            destinationVC.objectID = objectID
        }
    }
    
    // MARK: - Utility Methods
    private func updateTableView() {
        for bookRepresentation in self.bookSearchController.searchResults {
            let book = Book(bookRepresentation: bookRepresentation, context: self.tempContext)
            self.objectIDs.append(book.objectID)
        }
        self.tableView.reloadData()
        
        for (index, objectID) in objectIDs.enumerated() {
            let book = tempContext.object(with: objectID) as! Book
            bookController.fetchThumbnailFor(book: book) { (_) in
                DispatchQueue.main.async {
                    self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                }
            }
        }
    }

}
