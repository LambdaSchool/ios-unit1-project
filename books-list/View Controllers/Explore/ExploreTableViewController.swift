//
//  ExploreTableViewController.swift
//  books-list
//
//  Created by De MicheliStefano on 21.08.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import UIKit

class ExploreTableViewController: UITableViewController, UISearchBarDelegate, CollectionControllerProtocol, BookControllerProtocol {
    
    // - Properties
    @IBOutlet weak var searchBar: UISearchBar!
    var bookController: BookController?
    var collectionController: CollectionController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
    
    
    // MARK: - UISearchBarDelegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text,
            !searchTerm.isEmpty else { return }
        
        bookController?.fetchFromGoogleBooks(with: searchTerm) { (error) in
            guard error == nil else { return }
            
            DispatchQueue.main.async {
                self.searchBar.endEditing(true)
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookController?.searchedBooks.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExploreCell", for: indexPath) as! ExploreTableViewCell

        cell.book = bookController?.searchedBooks[indexPath.row]

        return cell
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowBookDetail" {
            guard let detailVC = segue.destination as? ExploreDetailViewController else { return }
            if let indexPath = tableView.indexPathForSelectedRow {
                detailVC.bookRepresentation = bookController?.searchedBooks[indexPath.row]
                detailVC.collectionController = collectionController
                detailVC.bookController = bookController
            }
        }
    }

}
