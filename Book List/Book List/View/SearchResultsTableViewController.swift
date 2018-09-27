//
//  SearchResultsTableViewController.swift
//  Book List
//
//  Created by Dillon McElhinney on 9/24/18.
//  Copyright © 2018 Dillon McElhinney. All rights reserved.
//

import UIKit
import CoreData

class SearchResultsTableViewController: UITableViewController, UISearchBarDelegate {
    
    // MARK: - Properties
    let bookSearchController = BookSearchController()
    let bookshelfController = BookshelfController()
    let bookController = BookController()
    
    @IBOutlet weak var searchBar: UISearchBar!
    

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.placeholder = "Search Books"
        searchBar.delegate = self

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
    // Makes a new search call when the user is about to get to the end of the table view
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (bookSearchController.searchResults.count - 5) {
            let page = bookSearchController.searchResults.count/20
            guard let searchTerm = searchBar.text else { return }
            bookSearchController.performSearch(with: searchTerm, page: page, reset: false) { (_) in
                DispatchQueue.main.async {
                    self.updateTableView()
                }
            }
        }
    }
    
    // MARK: - UI Search Bar Delegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        URLSession.shared.reset {}
        self.bookSearchController.resetResults()
        self.tableView.reloadData()
        guard let searchTerm = searchBar.text, !searchTerm.isEmpty else { return }
        searchBar.resignFirstResponder()
        self.bookSearchController.performSearch(with: searchTerm) { (_) in
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
            let bookRepresentation = bookSearchController.searchResults[indexPath.row]
            
            destinationVC.backgroundContext.performAndWait {
                let bookshelf = bookshelfController.fetchSingleBookshelf(title: "To read", context: destinationVC.backgroundContext)
                destinationVC.bookshelfController = bookshelfController
                destinationVC.book = Book(bookRepresentation: bookRepresentation, bookshelf: bookshelf, context: destinationVC.backgroundContext)
            }
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
