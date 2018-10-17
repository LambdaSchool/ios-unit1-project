//
//  SearchTableViewController.swift
//  Books
//
//  Created by Andrew Liao on 8/21/18.
//  Copyright © 2018 Andrew Liao. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController, UISearchBarDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        
        //create authorization client and check authorize if needed
        GoogleBooksAuthorizationClient.shared.authorizeIfNeeded(presenter: self) { (error) in
            if let error = error {
                NSLog("Error getting authorization: \(error)")
                return
            }
            
        }
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text else {return}
        
        bookController.fetchVolumeFromGoogle(searchTerm: searchTerm) { (error) in
            if let error = error {
                NSLog("Error Searching: \(error)")
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.searchBar.endEditing(true)
            }
        }
        
    }
 
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return bookController.searchResults.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath)
        cell.textLabel?.text = bookController.searchResults[indexPath.row].volumeInfo.title

        return cell
    }

    let bookController = BookController()
    @IBOutlet weak var searchBar: UISearchBar!
}
