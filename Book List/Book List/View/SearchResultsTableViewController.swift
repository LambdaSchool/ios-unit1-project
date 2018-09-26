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
    let bookshelfController = BookshelfController()
    let bookController = BookController()
    var searchController: UISearchController!
    
    lazy var tempContext: NSManagedObjectContext = {
        let tempContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        tempContext.parent = CoreDataStack.shared.mainContext
        return tempContext
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize with searchResultsController set to use this view controller to display the search results
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Books"
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchController.searchBar.endEditing(true)
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookSearchController.searchResults.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookResultCell", for: indexPath)
        let bookRepresentation = bookSearchController.searchResults[indexPath.row]
        
        cell.textLabel?.text = bookRepresentation.volumeInfo.title
        cell.detailTextLabel?.text = bookRepresentation.volumeInfo.authors?.joined(separator: ", ")
        
        if let imageData = bookRepresentation.thumbnailData {
            cell.imageView?.image = UIImage(data: imageData)
        }
        
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if indexPath.row == (bookSearchController.searchResults.count - 5) {
//            let page = bookSearchController.searchResults.count/20
//            guard let searchTerm = searchController.searchBar.text else { return }
//            bookSearchController.performSearch(with: searchTerm, page: page, reset: false) { (_) in
//                DispatchQueue.main.async {
//                    self.updateTableView()
//                }
//            }
//        }
//    }
    
    // MARK: - UI Search Results Updating
    func updateSearchResults(for searchController: UISearchController) {
        DispatchQueue.main.async {
            URLSession.shared.reset {}
            self.bookSearchController.resetResults()
            self.tableView.reloadData()
            guard let searchTerm = searchController.searchBar.text, !searchTerm.isEmpty else { return }
            self.bookSearchController.performSearch(with: searchTerm) { (_) in
                DispatchQueue.main.async {
                    self.updateTableView()
                }
            }
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddBookSegue" {
            guard let destinationVC = segue.destination as? BookDetailViewController,
            let indexPath = tableView.indexPathForSelectedRow else { return }
            let bookRepresentation = bookSearchController.searchResults[indexPath.row]
            
            let bookshelf = bookshelfController.fetchSingleBookshelf(title: "To read", context: CoreDataStack.shared.mainContext)
            destinationVC.bookshelfController = bookshelfController
            destinationVC.book = Book(bookRepresentation: bookRepresentation, bookshelf: bookshelf, context: destinationVC.childContext)
            
        }
    }
    
    // MARK: - Utility Methods
    private func updateTableView() {
        self.tableView.reloadData()
        for bookRepresentation in self.bookSearchController.searchResults {
            bookController.fetchImagesFor(bookRepresentation: bookRepresentation) { (_) in
                if let index = self.bookSearchController.searchResults.index(of: bookRepresentation) {
                    DispatchQueue.main.async {
                        self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                    }
                }
            }
        }
        
    }

}
