//
//  SearchBooksTableViewController.swift
//  Books
//
//  Created by Linh Bouniol on 8/20/18.
//  Copyright © 2018 Linh Bouniol. All rights reserved.
//

import UIKit

class SearchBooksTableViewController: UITableViewController, UISearchBarDelegate, SearchBookTableViewCellDelegate {
    
    // MARK: - Properties
    
    let searchController = SearchController()
    var bookController: BookController?
    var bookshelf: Bookshelf?
    
    // MARK: - Outlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
    }
    
    // MARK: - SearchBookTableViewCellDelegate
    
    func saveBook(for cell: SearchBookTableViewCell) {
        guard let searchResult = cell.searchResult, let bookshelf = bookshelf else { return }
        
        // call create book from bookController
        bookController?.createBook(with: searchResult, inBookshelf: bookshelf)
    }

    // MARK: - UISearchBarDelegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text, searchTerm.count > 0 else { return }
        
        // Dismiss keyboard
        searchBar.resignFirstResponder()
        
        searchController.performSearch(with: searchTerm, completion: { (searchResults, error) in
            if let error = error {
                NSLog("Error searching for books: \(error)")
            }
            self.tableView.reloadData()
        })
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchController.searchResults.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath) as! SearchBookTableViewCell

//        let searchResult = searchController.searchResults[indexPath.row]
//        cell.textLabel?.text = searchResult.title
//        cell.detailTextLabel?.text = searchResult.authors.joined(separator: ", ")
        
        cell.bookshelf = bookshelf
        cell.searchResult = searchController.searchResults[indexPath.row]
        cell.delegate = self

        return cell
    }
}
