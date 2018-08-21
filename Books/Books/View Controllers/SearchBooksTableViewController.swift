//
//  SearchBooksTableViewController.swift
//  Books
//
//  Created by Linh Bouniol on 8/20/18.
//  Copyright © 2018 Linh Bouniol. All rights reserved.
//

import UIKit

class SearchBooksTableViewController: UITableViewController, UISearchBarDelegate {
    
    let searchController = SearchController()
    
    @IBOutlet weak var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
    }

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
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath)

        let searchResult = searchController.searchResults[indexPath.row]
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.authors.joined(separator: ", ")

        return cell
    }
   
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}
